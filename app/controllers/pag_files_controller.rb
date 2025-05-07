class PagFilesController < ApplicationController
   # before_action :require_shibboleth_user

    def download
        base_path = Rails.application.credentials.dig(Rails.env.to_sym, :pag_dir)
        requested_path = base_path.present? ? Pathname.new(base_path).join(params[:path]).cleanpath : nil
          
        if requested_path.exist? && requested_path.file? && requested_path.to_s.start_with?(base_path.to_s)
          send_file requested_path, disposition: 'attachment'
        else
          render plain: "File not found or invalid path", status: :not_found
        end
      end
end
