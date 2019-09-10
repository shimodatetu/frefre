class UsersController < ApplicationController
  def index
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if params[:user][:agreement_term] == "0"
      flash.now[:failed_en] = "Please agree the terms of service"
      flash.now[:failed_jp] = "利用規約に同意してください"
      render :index
    elif params[:user][:agreement_policy] == "0"
      flash.now[:failed_en] = "Please agree the privacy policy"
      flash.now[:failed_jp] = "プライバシーポリシーに同意してください"
      render :index
    else
      if @user.save
        flash.now[:success] = "メールに届いたURLをクリックして、アカウントを有効かしてください。"
        UserMailer.account_activation(@user).deliver_now
        #RegisterMailer.send_confirm_mail(@user).deliver_now
        redirect_to '/account_activations/check'
      else
        flash.now[:failed_jp] = "登録に失敗しました"
        if @user.errors.any?
          @user.errors.full_messages.each do |message|
            flash.now[:failed_en] = message
            error_jp(message)
          end
        end
        render :index
      end
    end
  end

  def error_jp(mes_en)
    if mes_en == "Password can't be blank"
      flash.now[:failed_jp] = "パスワードが空になっています。"
    elsif mes_en == "Email can't be blank"
      flash.now[:failed_jp] = "メールアドレスが空になっています。"
    elsif mes_en == "Email has already been taken"
      flash.now[:failed_jp] = "すでに登録済みのメールアドレスです。"
    elsif mes_en == "Name can't be blank"
      flash.now[:failed_jp] = "名前が空になっています。"
    elsif mes_en == "Password confirmation doesn't match Password"
      flash.now[:failed_jp] = "パスワード確認がパスワードと一致しません。"
    elsif mes_en == "Password is too short (minimum is 6 characters)"
      flash.now[:failed_jp] = "パスワードが短すぎます。(最低６文字です)"
    elsif mes_en == "Password is too long (maximum is 32 characters)"
      flash.now[:failed_jp] = "パスワードが長すぎます。(最高32文字です)"
    elsif mes_en == "Name is invalid"
      flash.now[:failed_jp] = "名前は半角英数字でお願いします。"
      flash.now[:failed_en] = "Please input your username using half-width alphanumeric."
    elsif mes_en == "Password is invalid"
      flash.now[:failed_jp] = "パスワードは半角英数字でお願いします。"
      flash.now[:failed_en] = "Please input your password using half-width alphanumeric."
    end
  end

  def update
  end
  def show_image
    @image = User.find(params[:id])
    send_data @image.photo, :type => 'image/jpeg'
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
