class RegistrationsController < Devise::RegistrationsController

  protected

  def sign_up_params
    params.require(:user).permit(:token, :name, :email, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    @users_count = User.count('id')
    Statistic.update_statistics(registered_users: @users_count)
    @user = current_user.email
    UserMailer.welcome_email(@user).deliver_now
    after_sign_in_path_for(resource)
  end
end
