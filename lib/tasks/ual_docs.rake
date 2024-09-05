# frozen_string_literal: true

require "csv"

namespace :ual_docs do
    desc "UAL Solr metadata ingest"
    task :load_test_docs do
        puts "*********** Indexing local UAL Solr test fixtures ***********"
        docs = Dir["test/fixtures/files/solr_docs/*.json"].map { |f| JSON.parse File.read(f) }.flatten

        Blacklight.default_index.connection.add docs
        Blacklight.default_index.connection.commit
    end

    desc "UAL pull latest metadata from ual-geospatial-metadata repo and reindex in solr"
    task :reindex do
        clone_path = "tmp"
        repo_path = "#{clone_path}/ual-geospatial-metadata"
        repo_url = "git@github.com:ualibraries/ual-geospatial-metadata.git"

        puts "*********** Indexing production UAL Solr test fixtures ***********"
        if !File.directory? repo_path
            Git.clone(repo_url, nil, path: clone_path, depth: 1)
            puts "cloned #{repo_url} to #{repo_path}"
        else
            Git.open(repo_path).pull
            puts "updated #{repo_url}"
        end

        docs = Dir["#{repo_path}/**/*.json"].map { |f| JSON.parse File.read(f) }.flatten

        # Clear current index
        Blacklight.default_index.connection.delete_by_query('*:*')
        Blacklight.default_index.connection.commit


        Blacklight.default_index.connection.add docs
        Blacklight.default_index.connection.commit
    end

    desc "UAL geospatial metadata harvest and transformation"
    task :migrate do
        # mostly just using the geocombine gem here - https://github.com/OpenGeoMetadata/GeoCombine/tree/main

        ogm_source = "edu.uarizona"
        download_dir = ENV['OGM_PATH'] || "tmp/opengeometadata"
        match_table = Rails.root.join("lib", "tasks", "match_table.csv")

        puts "*********** Downloading remote UAL OGM data ***********"
        Rake::Task["geocombine:clone"].invoke(ogm_source)

        puts "*********** Transforming data ***********"
        Dir.glob("#{download_dir}/**/*.json") do |filename|
            if filename.include? "geoblacklight"
                puts "Transforming #{filename}"
                record = JSON.parse(File.read(filename))

                # Migrate it to Aardvark schema
                record_out = GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: record).run

                # clean non-digit chars from numerical fields
                record_out['gbl_indexYear_im'] = record_out['gbl_indexYear_im'].map { |year| year.gsub(/\D/, '') }
                
                # Access dct_references_s field to modify metadata
                dct_references_s = JSON.parse(record_out['dct_references_s'])
                
                # Remove references to geoserver from metadata
                dct_references_s.delete('http://www.opengis.net/def/serviceType/ogc/wcs')                
                dct_references_s.delete('http://www.opengis.net/def/serviceType/ogc/wfs')
                dct_references_s.delete('http://www.opengis.net/def/serviceType/ogc/wms')
                
                # Loop through match_table
                CSV.foreach(match_table, :headers => true) do |row|
                    # Replace Sequoia links with CyVerse/Campus Repo/UAir/S3 links
                    if (dct_references_s['http://schema.org/downloadUrl'].include? row['sequoia']) && (!row['public_link'].empty?)
                        dct_references_s['http://schema.org/downloadUrl'] = row['public_link']
                        
                        # Add filesize
                        record_out['gbl_fileSize_s'] = row['gbl_fileSize_s']
                    end

                end

                # Rewrite the field's value back to JSON
                record_out['dct_references_s'] = dct_references_s.to_json

                # overwrite data back to file later if we want to commit them
                # File.open(filename, 'w') { |file| file.write(JSON.dump(record_out)) }

                Blacklight.default_index.connection.add record_out
            end
        end
        Blacklight.default_index.connection.commit
        puts "*********** Metadata ingest succeeded ***********"

    end
end