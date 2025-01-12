class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :cas

  def cas
    auth = request.env['omniauth.auth']
    origin = request.env['omniauth.origin']
    Rails.logger.info(auth.inspect)

    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user
      if origin.present?
        redirect_to origin
      else
        redirect_to after_sign_in_path_for(@user)
      end

      set_flash_message(:notice, :success, kind: 'CAS') if is_navigational_format?
    else
      session['devise.cas_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path, alert: 'Authentication failed. Please try again.'
  end
end
