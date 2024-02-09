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
        # for now, assuming we don't have to change transform any fields

        ogm_source = "edu.uarizona"
        download_dir = ENV['OGM_PATH'] || "tmp/opengeometadata"

        puts "*********** Downloading remote UAL OGM data ***********"
        # geocombine uses the OGM_PATH environment variable to determine where to download data
        Rake::Task["geocombine:clone"].invoke(ogm_source)

        puts "*********** Transforming data ***********"
        Dir.glob("#{download_dir}/**/*.json") do |filename|
            # Load a record in geoblacklight v1 schema
            puts "Transforming #{filename}"
            record = JSON.parse(File.read(filename))
            # Migrate it to Aardvark schema
            record_out = GeoCombine::Migrators::V1AardvarkMigrator.new(v1_hash: record).run
            # overwrite data back to file later if we want to commit them
            # File.open(filename, 'w') { |file| file.write(JSON.dump(record_out)) }
            Blacklight.default_index.connection.add record_out
        end
        Blacklight.default_index.connection.commit
        
    end
end