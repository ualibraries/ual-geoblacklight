class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout :determine_layout if respond_to? :layout

        before_action :allow_geoblacklight_params

        def allow_geoblacklight_params
          # Blacklight::Parameters will pass these to params.permit
          blacklight_config.search_state_fields.append(Settings.GBL_PARAMS)
        end

        # Alias new_session_path as login_path for default devise config
        def new_user_session_path(*)
          user_shibd_omniauth_authorize_path
        end

        def after_sign_in_path_for(resource)
          request.env['omniauth.origin'] || stored_location_for(resource) || root_path
        end


  # Status page for Pingdom
  def status
    output = {
      "curr_datetime": DateTime.current
    }
    render json: output.to_json
  end
end
