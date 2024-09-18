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

    desc "Task to clear the current Solr index"
    task :clear_index do
        # Clear current index
        Blacklight.default_index.connection.delete_by_query('*:*')
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
            repo = Git.open(repo_path)
            repo.fetch('origin')
            repo.pull
            puts "updated #{repo_url}"
        end

        docs = Dir["#{repo_path}/**/*.json"].map { |f| JSON.parse File.read(f) }.flatten

        # Clear current index
        Blacklight.default_index.connection.delete_by_query('*:*')
        Blacklight.default_index.connection.commit


        Blacklight.default_index.connection.add docs
        Blacklight.default_index.connection.commit
    end
end