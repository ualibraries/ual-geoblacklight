class PagFilesController < ApplicationController
    before_action :authorize_pag_access
    def download
        #retrieves the :path parameter from the request, converts it to a string.
        raw_path = params[:path].to_s
        #CGI.unescape decodes percent-encoded characters and strip removes any leading or trailing whitespace.
        decoded_path = CGI.unescape(raw_path).strip
        logger.info("Decoded path: #{decoded_path}")

        base_path = Rails.application.credentials.dig(Rails.env.to_sym, :pag_dir)
        logger.info("Base path: #{base_path}")
    
        requested_path = if base_path.present?
          Pathname.new(base_path).join(decoded_path).cleanpath
        end

        if requested_path&.exist? && requested_path.file? && requested_path.to_s.start_with?(base_path.to_s)
          send_file requested_path, disposition: 'attachment'
        else
          render plain: "File not found or invalid path", status: :not_found
        end
      end

    private

    def authorize_pag_access
      uid = session[:shib_uid]
      isMemberOfTess = session[:has_pag_access]
      authorized = uid == "garrettsmith" || isMemberOfTess
      unless authorized
        if uid.blank?
          logger.info "UID is blanck so redirect to sign in"
          store_location_for(:user, request.original_url)
          redirect_to user_shibd_omniauth_callback_path(referrer: request.original_url)
         else
           # Logged in but unauthorized
           render plain: I18n.t("devise.failure.pag_not_authorized"), status: :forbidden
         end
      end
    end  

    # Display the PAG agreement message
    def pag_agreement
    end
end
