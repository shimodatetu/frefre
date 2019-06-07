class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])

      user.update_attribute(:activated,   true)

      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"

      flash["alert_en"] = "You successed to signup."
      flash["alert_jp"] = "会員登録に成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/profile"
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  private
  def log_in(user)
    session[:user_id] = user.id
  end
  def check

  end
end
