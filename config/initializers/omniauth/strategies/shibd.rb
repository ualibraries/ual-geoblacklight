module OmniAuth
  module Strategies
    class Shibd
      include OmniAuth::Strategy

      # This method determines if we're already authenticated via Shibboleth
      def authenticated?
        request.env['Shib-Session-ID']
      end

      def request_phase
        if authenticated?
          # If we're already authenticated, proceed to callback phase
          redirect callback_path
        else
          # Redirect to Shibboleth handler
          redirect '/Shibboleth.sso/Login'
        end
      end

      def callback_phase
        # Fail if we're not authenticated
        return fail!(:invalid_credentials) unless authenticated?

        # Log headers for debugging
        #Rails.logger.debug "Shibboleth Headers: #{request.env.select { |k,v| k.start_with?('HTTP_SHIB_', 'shibd', 'Shib-') }}"

        super
      end

      uid do
        shib_field("uid")
      end

      info do
        info = {}
        info[:email] = shib_field("mail")

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
