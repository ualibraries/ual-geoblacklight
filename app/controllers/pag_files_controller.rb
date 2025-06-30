class PagFilesController < ApplicationController
  before_action :authorize_pag_access, :set_paths, :is_valid_pag_file
  
  # Display the PAG agreement view
  def display_agreement
  end
  
  # Submit the PAG agreement
  def submit_agreement
    # User has submitted an agreement; record information to database and initiate #download
    if params[:commit] == "Agree"
      # To do: record the UID in Agreements table record
      # To do: record the path of the file in Agreements table record
      
      # Initiate download
      download

    # User has cancelled the agreement--return them from whence they came!
    else
      # If user's previous path exists, route to previous path (arrived via discovery)
      # if <user's previous page exists>
        # redirect_to <previous page>
      # Otherwise, route to home page (arrived via direct URL)
      # else
        # redirect_to root_path (arrived via direct path)
      # end
      # Provide flash notice that they cannot download the data item without agreeing to the terms, using message from devise.failure.pag_not_agreed
    end
  end
  
  private
  
    # Define @requested_path and @base_path for use in other methods
    def set_paths
      #retrieves the :path parameter from the request, converts it to a string.
      raw_path = params[:path].to_s
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
      uid = session[:shib_uid]
      isMemberOfTess = session[:has_pag_access]
      authorized = uid == "garrettsmith" || isMemberOfTess
      unless authorized
        if uid.blank?
          logger.info "UID is blank so redirect to sign in"
          store_location_for(:user, request.original_url)
          redirect_to user_shibd_omniauth_callback_path(referrer: request.original_url)
        else
          # Logged in but unauthorized
          render plain: I18n.t("devise.failure.pag_not_authorized"), status: :forbidden
        end
      end
    end
  
    # Download a requested PAG file
    def download

=begin
If statement (L73) for has_submitted_agreement is pseudo-code for now.
We want to verify that a user has submitted the agreement prior to downloading (extra security step).
=end

      # Ensure user submit_agreement, then download file
      # if has_submitted_agreement(shib_uid)
       send_file @requested_path, disposition: 'attachment'
      # end

=begin
If statement for routing is pseudo-code for now.
We want to send the user to their previous path/record, if it exists; to the homepage otherwise.
=end
      # If user's previous path exists, route to previous path (arrived via discovery)
      # if <user's previous page exists>
        # redirect_to <previous page>
        # Provide flash notice from devise.confirmations.pag_agreed

      # Otherwise, route to home page (arrived via direct URL)
      # else
      #  redirect_to root_path
      #  Provide flash notice from devise.confirmations.pag_agreed
      # end
    end



    
    # Check if a user has submitted a PAG agreement for the requested file
    # def has_submitted_agreement?(uid, fid)
      # pag_user = User.find(params[:uid])
      # if Agreement.find(pag_user)
        # Need to finish this
      # end
    # end

    # Check whether a requested PAG file path exists or not
    def is_valid_pag_file
      return (@requested_path&.exist? && @requested_path.file? && @requested_path.to_s.start_with?(@base_path.to_s))
    end
    
end
