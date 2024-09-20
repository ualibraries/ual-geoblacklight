=begin
Origin: https://github.com/projectblacklight/blacklight/blob/v7.37.0/app/components/blacklight/search_context_component.rb

Re-defines and overrides Blacklight's SearchContextComponent class to call ual_link_to_previous_document and ual_link_to_next_document, so that we can modify it to use the appropriate markup.
ual_link_to_previous_document and ual_link_to_next_document are defined in application_helper.rb.
=end

# frozen_string_literal: true

module Blacklight
  class SearchContextComponent < Blacklight::Component
    with_collection_parameter :search_context

    def initialize(search_context:, search_session:)
      @search_context = search_context
      @search_session = search_session
    end

    def render?
      @search_context.present? && (@search_context[:prev] || @search_context[:next])
    end

    def item_page_entry_info
      Deprecation.silence(Blacklight::CatalogHelperBehavior) do
        helpers.item_page_entry_info
      end
    end

    # Replacement of link_to_previous_document so that we can modify markup/classes
    def ual_link_to_previous_document(document = nil, *args, **kwargs)
      Deprecation.silence(Blacklight::UrlHelperBehavior) do
        helpers.ual_link_to_previous_document(document || @search_context[:prev], *args, **kwargs)
      end
    end

    # Replacement of link_to_next_document so that we can modify markup/classes
    def ual_link_to_next_document(document = nil, *args, **kwargs)
      Deprecation.silence(Blacklight::UrlHelperBehavior) do
        helpers.ual_link_to_next_document(document || @search_context[:next], *args, **kwargs)
      end
    end
  end
end