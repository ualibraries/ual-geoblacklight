class PagFilesController < ApplicationController
  before_action :set_paths, :is_valid_pag_file, :set_current_user, :authorize_pag_access
  
  # Display the PAG agreement view
  def display_agreement
    render template: "pag_files/display_agreement", formats: [:html]
  end
  
  # Submit a PAG agreement
  def submit_agreement
    # User has submitted an agreement; record agreement to database and initiate #download
    if params[:commit] == "Agree"
      clean_path = @requested_path.to_s.sub(/\/agreement$/, '')
      PagAgreement.create(path: clean_path, user_id:current_user.id)

      download

    # User has cancelled the agreement--return them from whence they came!
    else
      # To do:
      # if previous_path exists, redirect_to previous_path
      # else, redirect_to root_path
      # Both cases: Provide flash notice that they cannot download the data item without agreeing to the terms, using message from devise.failure.pag_not_agreed
    end
  end

  # Download a requested PAG file
  def download
    if has_submitted_agreement(@current_user_shib_uid)
      send_file @requested_path, disposition: 'attachment'
      # To-do:
      # if previous_path exists, redirect_to previous_path
      # else, redirect_to root_path
    else
      # Sanitize param: remove trailing /agreement if it's there
      clean_path = params[:path].to_s.sub(/\/agreement$/, '') # Clean path is correct at the first call of #download
      redirect_to pag_agreement_path(path: clean_path)
    end
  end
  
  private

    # Save current user ID to a variable for reference in other methods
    def set_current_user
      @current_user_shib_uid = session[:shib_uid]
      @pag_user = User.find_by(uid: @current_user_shib_uid)
      @pag_user_id = @pag_user.id
    end
    
    
    # Define @requested_path and @base_path for use in other methods
    def set_paths
      #retrieves the :path parameter from the request, converts it to a string.
      
      raw_path = params[:path].to_s.sub(/\/agreement$/, '') # Strip trailing /agreement
      #CGI.unescape decodes percent-encoded characters and strip removes any leading or trailing whitespace.
      decoded_path = CGI.unescape(raw_path).strip
      logger.info("Decoded path: #{decoded_path}")
      
      @base_path = Rails.application.credentials.dig(Rails.env.to_sym, :pag_dir)
      logger.info("Base path: #{@base_path}")
      
      @requested_path = if @base_path.present?
        Pathname.new(@base_path).join(decoded_path).cleanpath
      end
    end
    
    # Determine whether a user is authorized to access restricted data or not
    def authorize_pag_access
      isMemberOfTess = session[:has_pag_access]
      authorized = @current_user_shib_uid == "garrettsmith" || isMemberOfTess
      unless authorized
        if @current_user_shib_uid.blank?
          logger.info "UID is blank so redirect to sign in"
          store_location_for(:user, request.original_url)
          redirect_to user_shibd_omniauth_callback_path(referrer: request.original_url)
        else
          # Logged in but unauthorized
          render plain: I18n.t("devise.failure.pag_not_authorized"), status: :forbidden
        end
      end
    end


    # Determine if user has submitted a PAG agreement for the requested file
    def has_submitted_agreement(current_user)
      return PagAgreement.where(user_id: @pag_user_id, path: @requested_path).exists?
    end

    # Determine whether a requested PAG file path exists or not
    def is_valid_pag_file
      return (@requested_path&.exist? && @requested_path.file? && @requested_path.to_s.start_with?(@base_path.to_s))
    end
    
end
