class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

        before_action :allow_geoblacklight_params

        # Store location for redirection after sign-in
        before_action :store_user_location!, if: :storable_location?

        def allow_geoblacklight_params
          # Blacklight::Parameters will pass these to params.permit
          blacklight_config.search_state_fields.append(Settings.GBL_PARAMS)
        end

        # Determine if the current request's location should be stored
        def storable_location?
          request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
        end

        # Store the current location for the user
        def store_user_location!
          store_location_for(:user, request.fullpath)
        end

        # Redirect to the stored location after sign-in
        def after_sign_in_path_for(resource)
          stored_location = stored_location_for(resource)
          Rails.logger.debug "Stored Location: #{stored_location}"
          stored_location || request.env['omniauth.origin'] || root_path
        end

        # Alias new_session_path as login_path for default devise config
        def new_user_session_path(*)
          user_shibd_omniauth_authorize_path
        end

  # Status page for Pingdom
  def status
    output = {
      "curr_datetime": DateTime.current
    }
    render json: output.to_json
  end
end
