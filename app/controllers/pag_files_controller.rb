class PagFilesController < ApplicationController
  before_action :set_paths, only: [:download, :submit_agreement]
  before_action :validate_pag_file_routing, only: [:download]
  before_action :authorize_pag_access, only: [:download, :submit_agreement]
  
  # Display the PAG agreement view
  def display_agreement
    session[:pag_previous_path] = request.referer
    render template: "pag_files/display_agreement", formats: [:html]
  end
  
  # Submit a PAG agreement
  def submit_agreement
    # User has agreed; record agreement to database and initiate #download
    if params[:commit] == "Agree"
      clean_path = @requested_path.to_s.sub(/\/agreement$/, '')
      PagAgreement.create(path: clean_path, user_id:current_user.id)
      redirect_to session[:pag_previous_path], notice: t('geoblacklight.pag.pag_agreed')
    # User has cancelled the agreement--return them from whence they came!
    else
      redirect_to session[:pag_previous_path], alert: t('geoblacklight.pag.pag_not_agreed')
    end
  end
  
  # Download a requested PAG file
  def download
    if has_submitted_agreement?
      send_file @requested_path, disposition: 'attachment'
    else 
      # Sanitize param: remove trailing /agreement if it's there
      clean_path = params[:path].to_s.sub(/\/agreement$/, '')
      redirect_to pag_agreement_path(path: clean_path)
    end
  end

  # Ensure valid PAG file, route to not found otherwise
  def validate_pag_file_routing
    unless is_valid_pag_file?
      redirect_to not_found_path and return
    end
  end
  
  private
    
    # Define @requested_path and @base_path for use in other methods
    def set_paths
      # Retrieves the :path parameter from the request, converts it to a string. Strips trailing /agreement to prevent infinite looping of redirect
      raw_path = params[:path].to_s.sub(/\/agreement$/, '')
      # CGI.unescape decodes percent-encoded characters and removes leading or trailing whitespace.
      decoded_path = CGI.unescape(raw_path).strip
      @base_path = Rails.application.credentials.dig(Rails.env.to_sym, :pag_dir)
      # @requested path becomes the full file path the user is requesting
      @requested_path = if @base_path.present?
        Pathname.new(@base_path).join(decoded_path).cleanpath
      end
    end
    
    # Determine whether a user is authorized to access restricted data or not
    def authorize_pag_access      
      # Ensure user is logged in; force login if not
      if current_user.nil? || current_user.uid.blank?
        store_location_for(:user, request.original_url)
        redirect_to user_shibd_omniauth_callback_path and return
      end
      
      # Determine if user is authorized to download PAG data
      authorized_pag_user = session[:has_pag_access]
      
      # User is logged in but unauthorized, notify user they're not authorized
      unless authorized_pag_user
        render plain: I18n.t("devise.failure.pag_not_authorized"), status: :forbidden and return
      end
    end
    
    # Determine if user has submitted a PAG agreement for the requested file
    def has_submitted_agreement?
      return PagAgreement.exists?(user_id: current_user.id, path: @requested_path.to_s)
    end

    # Determine whether a requested PAG file path exists or not
    def is_valid_pag_file?
      return (@requested_path.exist? && @requested_path.file? && @requested_path.to_s.start_with?(@base_path.to_s))
    end
    
end
