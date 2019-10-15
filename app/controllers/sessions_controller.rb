class SessionsController < ApplicationController
  def index
  end

  def new
  end
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password]) && user.activated? && user.oauth == false && user.admit == true
      log_in user
      flash["alert_en"] = "You successed to login"
      flash["alert_jp"] = "ログインに成功しました。"
      flash["alert_type"] = "success"
      redirect_to root_path, success: 'ログインに成功しました'
    else
      flash.now[:failed_en] = "Mail address or password is wrong."
      flash.now[:failed_jp] = "メールアドレスかパスワードが間違っています。"
      render :index
    end
  end
  def login_auth
    user_uid = request.env["omniauth.auth"].uid
    signup_yet = false
    if user_uid != nil && user = User.find_by(uid: user_uid)
      if user.admit == true
        session[:user_id] = user.id
        signup_yet = true
        redirect_to root_path
      end
    end
    if signup_yet == false
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user.save
        #session[:user_id] = user.id
        session[:oauth_id] = user.id
        redirect_to '/sessions/oauth_complete'
      else
        redirect_to "/sessions/new"
      end
    end
  end

  def oauth_complete
    @user = User.find_by(id: session[:oauth_id])
  end
  def create_oauth
    @user = User.find_by(id: session[:oauth_id])
    if params[:user][:agreement_term] == "0"
      flash.now[:failed_en] = "Please agree the terms of service"
      flash.now[:failed_jp] = "利用規約に同意してください"
      render :index
    else
      if @user.update(name: params[:user][:name],admit:true)
        log_in @user
        flash["alert_en"] = "You successed to signup."
        flash["alert_jp"] = "会員登録に成功しました。"
        flash["alert_type"] = "success"
        redirect_to "/profile"
      else
        flash.now[:failed_jp] = "登録に失敗しました"
        if @user.errors.any?
          @user.errors.full_messages.each do |message|
            flash.now[:failed_en] = message
            if message== "Name is invalid"
              flash.now[:failed_jp] = "名前は半角英数字でお願いします。"
              flash.now[:failed_en] = "Please input your username using half-width alphanumeric."
            end
          end
        end
        render :index
      end
    end
  end
  def destroy
    session[:user_id] = nil
    redirect_to "/"
  end
  private
  def log_in(user)
    reset_session
    session[:user_id] = user.id
  end

end
