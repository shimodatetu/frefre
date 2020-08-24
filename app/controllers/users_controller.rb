class UsersController < ApplicationController
  def index
    @user = User.new
  end
  def new_auth
  end
  def test
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    @user.profile_en = "Nice to meet you!"
    @user.profile_jp = "よろしくお願いします！"
    for i in 1..100
      user_search_id = @user.name + rand(1000000).to_s
      if User.find_by(user_search_id:user_search_id) == nil
        @user.user_search_id = user_search_id
        break
      end
    end
    if params[:user][:agreement_term] == "0"
      flash[:failed_en] = "Please agree the terms of service"
      flash[:failed_jp] = "利用規約に同意してください"
      render :index
    else
      @users = User.where(email: @user.email.downcase)
      user_exist = false
      for user in @users do
        if user.provider == nil
          user_exist = true
        end
      end
      if @user.usertype == "delete"
        flash[:failed_en] = "This acount is freezed."
        flash[:failed_jp] = "このアカウントは凍結しています"
        render :index
      elsif user_exist == true
        flash[:failed_en] = "This mail address is already registered."
        flash[:failed_jp] = "このメールアドレスはすでに登録されています。"
        render :index
      elsif @user.save
        flash[:success] = "メールに届いたURLをクリックして、アカウントを有効化してください。"
        UserMailer.account_activation(@user).deliver_now
        redirect_to '/account_activations/check'
      else
        flash[:failed_jp] = "登録に失敗しました"
        if @user.errors.any?
          @user.errors.full_messages.each do |message|
            flash[:failed_en] = message
            error_jp(message)
          end
        end
        render :index
      end
    end
  end

  def error_jp(mes_en)
    if mes_en == "Password can't be blank"
      flash[:failed_jp] = "パスワードが空になっています。"
    elsif mes_en == "Email can't be blank"
      flash[:failed_jp] = "メールアドレスが空になっています。"
    elsif mes_en == "Email has already been taken"
      flash[:failed_jp] = "すでに登録済みのメールアドレスです。"
    elsif mes_en == "Name can't be blank"
      flash[:failed_jp] = "名前が空になっています。"
    elsif mes_en == "Password confirmation doesn't match Password"
      flash[:failed_jp] = "パスワード確認がパスワードと一致しません。"
    elsif mes_en == "Password is too short (minimum is 6 characters)"
      flash[:failed_jp] = "パスワードが短すぎます。(最低６文字です)"
    elsif mes_en == "Password is too long (maximum is 32 characters)"
      flash[:failed_jp] = "パスワードが長すぎます。(最高32文字です)"
    elsif mes_en == "Name is invalid"
      flash[:failed_jp] = "ユーザーネームは半角英数字でお願いします。"
      flash[:failed_en] = "Please input your username using half-width alphanumeric."
    elsif mes_en == "Name is too long (maximum is 32 characters)"
      flash[:failed_jp] = "ユーザーネームが長すぎます。(最高32文字です)"
      flash[:failed_en] = "Username is too long (maximum is 32 characters)"
    elsif mes_en == "Password is invalid"
      flash[:failed_jp] = "パスワードは半角英数字でお願いします。"
      flash[:failed_en] = "Please input your password using half-width alphanumeric."
    elsif mes_en == "Email is invalid"
      flash[:failed_jp] = "無効なメールアドレスです。"
      flash[:failed_en] = "Email is invalid."
    end
    profile_en = "Nice to meet you!"
    profile_jp = "よろしくお願いします！"
    @user = User.new(name:params[:user][:name],email:params[:user][:email],agreement_term:params[:user][:agreement_term],profile_en:profile_en,profile_jp:profile_jp)
  end

  def update
    User.find_by(id:current_user.id).update(avater:params[:user][:avater],image:0)
  end
  def show_image
    @image = User.find_by(id:params[:id])
    send_data @image.photo, :type => 'image/jpeg'
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
