=begin
Origin: https://github.com/projectblacklight/blacklight/blob/v7.37.0/app/components/blacklight/start_over_button_component.rb

Re-defines and overrides Blacklight's StartOverButtonComponent class to add AZ Bootstrap classes and add html_safe for use of icons.
=end

# frozen_string_literal: true

module Blacklight
  class StartOverButtonComponent < Blacklight::Component
    def call
      link_to t('blacklight.search.start_over').html_safe, start_over_path, class: 'catalog_startOverLink btn btn-outline-blue'
    end

    private

    ##
    # Get the path to the search action with any parameters (e.g. view type)
    # that should be persisted across search sessions.
    def start_over_path query_params = params
      Deprecation.silence(Blacklight::UrlHelperBehavior) do
        helpers.start_over_path(query_params)
      end
    end
  end
end