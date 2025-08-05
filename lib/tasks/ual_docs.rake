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

    desc "UAL pull metadata from ual-geospatial-metadata repo and reindex in solr"
    task :reindex, [:branch] do |task, args|
        puts "*********** Indexing production UAL Solr test fixtures ***********"
        clone_path = "tmp"
        repo_name = "ual-geospatial-metadata"
        repo_path = "#{clone_path}/#{repo_name}"
        repo_url = "git@github.com:ualibraries/#{repo_name}.git"

        # Set 'main' as default branch, if none provided
        args.with_defaults(branch: 'main')
        repo_branch = args[:branch]

        unless File.directory? repo_path
          begin
            Git.clone(repo_url, nil, path: clone_path, depth: 1)
            puts "Cloned #{repo_url} to #{repo_path}"
          rescue => e
            puts "Failed to clone #{repo_url}: #{e.message}"
            return
          end
        end

        begin
          origin = "origin"
          repo = Git.open(repo_path)
          repo.fetch('origin', {:ref => '+refs/heads/*:refs/remotes/origin/*'} )
          repo.branch(repo_branch).checkout
          repo.reset_hard("#{origin}/#{repo_branch}")
          puts "Updated #{repo_name} on branch '#{repo.current_branch}'"
        rescue => e
          puts "Failed to fetch/checkout/pull branch '#{repo_branch}': #{e.message}"
          return
        end

        docs = Dir["#{repo_path}/**/*.json"].map { |f| JSON.parse File.read(f) }.flatten

        # Clear current index
        Blacklight.default_index.connection.delete_by_query('*:*')
        Blacklight.default_index.connection.commit

        Blacklight.default_index.connection.add docs
        Blacklight.default_index.connection.commit
    end
end
