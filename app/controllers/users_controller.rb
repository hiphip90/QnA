class UsersController < ApplicationController
  def request_email
    @user = User.new
  end

  def finish_signup
    @user = User.build_for_oauth(params[:user][:email])
    if @user.save
      redirect_to root_path, notice: 'Your email was updated. We have sent you a confirmation email.'
    else
      render :request_email
    end
  end

  private
    def user_params
      params.require(:user).permit(:email)
    end
end
