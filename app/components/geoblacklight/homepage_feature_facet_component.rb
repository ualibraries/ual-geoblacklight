# Origin: https://github.com/geoblacklight/geoblacklight/blob/v4.4.0/app/components/geoblacklight/homepage_feature_facet_component.rb
#
# Re-defines GeoBlacklight's HomepageFeatureFacetComponent class so we can override its corresponding template. No changes/overrides made to this file other than adding comments.

# frozen_string_literal: true

module Geoblacklight
  class HomepageFeatureFacetComponent < ViewComponent::Base
    def initialize(icon:, label:, facet_field:, response:)
      @icon = icon
      @label = label
      @facet_field = facet_field
      @response = response
      super
    end
  end
end
