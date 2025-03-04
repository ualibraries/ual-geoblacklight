module OmniAuth
  module Strategies
    class Shibd
      include OmniAuth::Strategy

      ALLOWED_AFFILIATIONS = %w[faculty staff student dcc retiree emeritus gradasst studentworker].freeze


      # This method determines if we're already authenticated via Shibboleth
      def authenticated?
        request.env['Shib-Session-ID']
      end

     # Check if the user's primary affiliation is allowed
      def allowed_affiliation?
        affiliation = shib_field("primary-affiliation")
        Rails.logger.debug "User affiliation: #{affiliation.inspect}"
        ALLOWED_AFFILIATIONS.include?(affiliation)
      end    
  

      def request_phase
        redirect callback_path
      end

      def callback_phase
        # Fail if we're not authenticated
        #return fail!(:invalid_credentials) unless authenticated?
        unless authenticated?
          error_message = "You entered an invalid NetID or password"
          request.env["omniauth.error.message"] = error_message
          return fail!(:invalid_credentials, error_message)
        end

        # Log headers for debugging
        #Rails.logger.debug "Shibboleth Headers: #{request.env.select { |k,v| k.start_with?('HTTP_SHIB_', 'shibd', 'Shib-') }}"

        # Check if the user's primary affiliation is allowed
        unless allowed_affiliation?
          error_message = "Your affiliation does not have access to this application"
          request.env["omniauth.error.message"] = error_message
          return fail!(:invalid_affiliation, error_message)
        end

        super
      end

      uid do
        shib_field("uid")
      end

      info do
        info = {}
        info[:email] = shib_field("mail")
        info[:affiliation] = shib_field("primary-affiliation")

        info
      end

      private
  
      def shib_field(field)
        return nil if field.nil?

        value = request.env["Shib-#{field}"]

        # Handle multi-valued attributes (semicolon-separated)
        if value.is_a?(String) && value.include?(';')
          value.split(';').map(&:strip)
        else
          value
        end
      end
    end
  end
end
