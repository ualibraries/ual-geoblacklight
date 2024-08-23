# frozen_string_literal: true
# lib/slackistrano/custom_slack_messaging.rb
if defined?(Slackistrano::Messaging)
  module Slackistrano
    class CustomSlackMessaging < Messaging::Base
      def app_name
        "Geoblacklight"
      end

      def payload_for_starting
        {
          attachments: [{
                          color: "#4d91f7",
                          title: app_name,
                          fields: [{
                                     title: "Environment",
                                     value: stage,
                                     short: true
                                   }, {
                                     title: "Branch",
                                     value: branch,
                                     short: true
                                   }, {
                                     title: "Deployer",
                                     value: deployer,
                                     short: true
                                   }],
                          text: "Deployment has started...",
                          fallback: super[:text]
                        }],
        }
      end

      # Suppress updating message.
      def payload_for_updating
        nil
      end

      # Suppress reverting message.
      def payload_for_reverting
        nil
      end

      def payload_for_updated
        {
          attachments: [{
                          color: "#00c100",
                          title: app_name,
                          fields: [{
                                     title: "Environment",
                                     value: stage,
                                     short: true
                                   }, {
                                     title: 'Branch',
                                     value: branch,
                                     short: true
                                   }, {
                                     title: 'Deployer',
                                     value: deployer,
                                     short: true
                                   }, {
                                     title: 'Time',
                                     value: elapsed_time,
                                     short: true
                                   }],
                          text: 'Deployment successful :rocket:',
                          fallback: super[:text]
                        }],
        }
      end

      def payload_for_reverted
        {
          attachments: [{
                          color: '#eba211',
                          title: app_name,
                          fallback: super[:text] ,
                          text: super[:text]
                        }],
        }
      end

      def payload_for_failed
        {
          attachments: [{
                          color: '#ff0909',
                          title: app_name,
                          text: "Deployment failed :fire: #{super[:text]}",
                          fallback: super[:text]
                        }],
        }
      end

      # Override the deployer helper to pull the best name available (git, password file, env vars).
      # See https://github.com/phallstrom/slackistrano/blob/master/lib/slackistrano/messaging/helpers.rb
      def deployer
        name = `git config user.name`.strip
        name = nil if name.empty?
        name ||= ENV['GIT_USER'] || "Anonymous user"
        name
      end
    end
  end
end