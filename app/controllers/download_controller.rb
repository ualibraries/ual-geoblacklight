class DownloadController < ApplicationController
  PRIVATE_FILES_PATH_ABS = File.expand_path("/app/test/fixtures/files/restricted/pag")

  def show
    requested_relative_path = "#{params[:filepath]}.#{params[:format]}"

    if requested_relative_path.blank?
      render plain: "Invalid path.", status: :bad_request
      return
    end

    # Attempt to construct the full, absolute path ---
    # File.join helps, but doesn't prevent '..' traversal on its own initially.
    # File.expand_path will resolve '..' components *after* joining.
    intended_full_path = File.expand_path(File.join(PRIVATE_FILES_PATH_ABS, requested_relative_path))
    Rails.logger.debug("Requested file path: #{requested_relative_path}")
    Rails.logger.debug("Intended file full path: #{intended_full_path}")

    # CRITICAL SECURITY CHECK: Confine to PRIVATE_FILES_PATH ---
    # Check if the resolved absolute path *still starts with* the base private path.
    # This prevents traversal attacks (e.g., /download/path/../../etc/passwd).
    # We add File::SEPARATOR to prevent matching "/private_files_extra" if base is "/private_files"
    unless intended_full_path.start_with?(PRIVATE_FILES_PATH_ABS + File::SEPARATOR) || intended_full_path == PRIVATE_FILES_PATH_ABS
       Rails.logger.warn("Directory Traversal Attempt: User #{current_user.id} requested '#{requested_relative_path}', resolved to '#{intended_full_path}' which is outside '#{PRIVATE_FILES_PATH_ABS}'")
       render plain: "Access Denied: Invalid path.", status: :forbidden # Or 404 to obscure
       return
    end

    # Check if the confined path exists and is a file ---
    if File.exist?(intended_full_path) && File.file?(intended_full_path)
      # Send the file - use the original requested path's basename for the download filename
      send_file(
        intended_full_path,
        filename: File.basename(requested_relative_path),
        type: "application/octet-stream",
        disposition: 'attachment'
      )
    else
      Rails.logger.error("File not found: '#{intended_full_path}'")
      render plain: "File not found.", status: :not_found
    end

  rescue => e # Catch potential errors during path processing
    Rails.logger.error("Error processing path download for '#{requested_relative_path}': #{e.message}")
    render plain: "Error processing request.", status: :internal_server_error
  end
end
