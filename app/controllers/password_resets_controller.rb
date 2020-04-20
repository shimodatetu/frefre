class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # (1) への対応

  def new
  end

  def new_check
  end

  def create
    @users = User.where(email: params[:password_reset][:email].downcase)
    user_exist = false
    for user in @users do
      if user.provider == nil
        user_exist = true
        user.create_reset_digest
        user.send_password_reset_email
        flash[:info] = "Email sent with password reset instructions"
        render "new_check"
        return
      end
    end
    if user_exist == false
      flash.now[:failed_jp] = "メールアドレスが間違っています。"
      flash.now[:failed_en] = "Email address is wrong."
      render "new"
    end
  end

  def edit
  end


  def update
    if params[:user][:password].empty? || params[:user][:password] !=  params[:user][:password_confirmation]              # (3) への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)          # (4) への対応
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 有効なユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to root_path
      end
    end
end
