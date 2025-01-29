module OmniAuth
  module Strategies
    class Shibd
      include OmniAuth::Strategy
      
      option :name, 'shibd'
      
      # Configurable options
      option :debug, false
      
      # This method determines if we're already authenticated via Shibboleth
      def authenticated?
        request.env['Shib-Session-ID'] || request.env['HTTP_SHIB_SESSION_ID']
      end
      
      def request_phase
        if authenticated?
          # If we're already authenticated, proceed to callback phase
          redirect callback_path
        else
          # Redirect to Shibboleth handler
          [ 
            302,
            {
              'Location' => '/Shibboleth.sso/Login',
              'Content-Type' => 'text/plain'
            },
            ["Redirecting to Shibboleth..."]
          ]
        end
      end
      
      def callback_phase
        # Fail if we're not authenticated
        return fail!(:invalid_credentials) unless authenticated?
        
        # Log headers if debug is enabled
        if options.debug
          Rails.logger.debug "Shibboleth Headers: #{request.env.select { |k,v| k.start_with?('HTTP_SHIB_', 'shibd', 'Shib-') }}"
        end
        
        super
      end
      
      uid do
      end
      
      info do
        info = {}
        
        info
      end

      private
      
      def shib_field(field)
        return nil if field.nil?
        
        # Try different possible header formats
        value = request.env["HTTP_SHIB_#{field.upcase}"] ||
                request.env["Shib-#{field}"] ||
                request.env["shibd-#{field}"] ||
                request.env[field]
                
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