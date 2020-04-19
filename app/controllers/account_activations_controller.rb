class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation, params[:id])
      if !user.activated?
        user.update_attribute(:activated,   true)

        user.update_attribute(:activated_at, Time.zone.now)
        log_in user
        flash[:success] = "Account activated!"

        flash["alert_en"] = "You successed to signup."
        flash["alert_jp"] = "会員登録に成功しました。"
        flash["alert_type"] = "success"
        redirect_to "/profile"
      else
        log_in user
        flash["alert_en"] = "You successed to login."
        flash["alert_jp"] = "ログインに成功しました。"
        flash["alert_type"] = "success"
      end
    else
      flash[:danger] = "Invalid activation link"

      flash["alert_en"] = "You failed to signup."
      flash["alert_jp"] = "会員登録に失敗しました。"
      flash["alert_type"] = "error"
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
