class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_via_oauth, except: :after_sign_in_path_for

  def facebook
  end

  def twitter
  end

  private
    def sign_in_via_oauth
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if !@user.confirmed_for_twitter?
        redirect_to request_email_path(@user)
      elsif @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: "#{action_name}".capitalize) if is_navigational_format?
      end
    end
end