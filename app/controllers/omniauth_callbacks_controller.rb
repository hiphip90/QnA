class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_via_oauth, except: :after_sign_in_path_for

  def facebook
  end

  def twitter
  end

  private
    def sign_in_via_oauth
      auth = request.env['omniauth.auth']
      @user = User.find_for_oauth(auth)
      if @user
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "#{action_name}".capitalize) if is_navigational_format?
      else
        cookies[:provider] = { value: auth.provider, expires_at: 15.minutes.from_now }
        cookies[:uid] = { value: auth.uid, expires_at: 15.minutes.from_now }
        redirect_to request_email_path
      end
    end
end