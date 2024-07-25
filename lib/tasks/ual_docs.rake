# frozen_string_literal: true

namespace :ual_docs do
    desc "UAL Solr metadata ingest"
    task :load do
        puts "*********** Indexing local UAL Solr test fixtures ***********"
        docs = Dir["test/fixtures/files/solr_docs/*.json"].map { |f| JSON.parse File.read(f) }.flatten

        Blacklight.default_index.connection.add docs
        Blacklight.default_index.connection.commit
    end

    desc "UAL geospatial metadata harvest and transformation"
    task :migrate do
        # mostly just using the geocombine gem here - https://github.com/OpenGeoMetadata/GeoCombine/tree/main

        ogm_source = "edu.uarizona"
        download_dir = ENV['OGM_PATH'] || "tmp/opengeometadata"
        match_table = JSON.parse(File.read("lib/tasks/match_table.json"))

        puts "*********** Downloading remote UAL OGM data ***********"
        Rake::Task["geocombine:clone"].invoke(ogm_source)

        puts "*********** Transforming data ***********"
        Dir.glob("#{download_dir}/**/*.json") do |filename|
            if filename.include? "geoblacklight"
                puts "Transforming #{filename}"
                record = JSON.parse(File.read(filename))

                # Migrate it to Aardvark schema
                record_out = GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: record).run

                # change field keys not in Aardvark migration
                record_out['dcat_bbox'] = record_out.delete('solr_geom')

                # clean non-digit chars from numerical fields
                record_out['gbl_indexYear_im'] = record_out['gbl_indexYear_im'].map { |year| year.gsub(/\D/, '') }
                
                # Replace Sequoia links with CyVerse links
                dct_references_s = JSON.parse(record_out['dct_references_s'])
                
                match_table.each do |item, details|
                    if (dct_references_s['http://schema.org/downloadUrl'].include? details['sequoia']) && (!details['cyverse'].empty?)
                        substring_start = record_out['dct_references_s'].index('http://sequoia.library.arizona.edu')
                        sequoia_substring = record_out['dct_references_s'][substring_start, record_out['dct_references_s'].length-1]
                        sequoia_substring = sequoia_substring.gsub('"}', '')
                        substring_end =  substring_start + sequoia_substring.length-1
                       
                        cyverse_replacement = record_out['dct_references_s'][0..substring_start-1] + details['cyverse'] + record_out['dct_references_s'][substring_end+1..record_out['dct_references_s'].length]
                        record_out['dct_references_s'] = cyverse_replacement
                    end
                end

                # overwrite data back to file later if we want to commit them
                # File.open(filename, 'w') { |file| file.write(JSON.dump(record_out)) }

                Blacklight.default_index.connection.add record_out
            end
        end
        Blacklight.default_index.connection.commit
        puts "*********** Metadata ingest succeeded ***********"

    end
end