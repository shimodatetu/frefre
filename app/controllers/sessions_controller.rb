class SessionsController < ApplicationController
  def index
  end

  def event_login
  end

  def new
  end
  def login_post
    user = User.find_by(email: params[:session][:email])
    if user && user.activated? && user.oauth == false && user.admit == true && user.authenticate(params[:session][:password])
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

  def login_post2
    p params[:session][:id].to_i
    user = User.find_by(id: params[:session][:id].to_i)
    if user && user.usertype == "event"
      log_in user
      flash["alert_en"] = "You successed to login"
      flash["alert_jp"] = "ログインに成功しました。"
      flash["alert_type"] = "success"
      redirect_to "/thread/show/11", success: 'ログインに成功しました'
    else
      flash.now[:failed_en] = "Mail address or password is wrong."
      flash.now[:failed_jp] = "メールアドレスかパスワードが間違っています。"
      render :event_login
    end
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
        flash["alert_en"] = "You successed to login"
        flash["alert_jp"] = "ログインに成功しました。"
        flash["alert_type"] = "success"
        redirect_to root_path
      end
    end
    if signup_yet == false
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user.save
        #session[:user_id] = user.id
        session[:oauth_id] = user.id
        redirect_to '/oauth_complete'
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
      render :oauth_complete
    else
      name = params[:user][:name]
      if name == ""
        flash.now[:failed_en] = "Name can't be blank"
        flash.now[:failed_jp] = "名前が空になっています。"
        render :oauth_complete
      elsif name.length > 32
        flash.now[:failed_en] = "Username is too long (maximum is 32 characters)"
        flash.now[:failed_jp] = "ユーザーネームが長すぎます。(最高32文字です)"
        render :oauth_complete
      elsif !(name =~ /\A[a-z0-9]+\z/i)
        flash.now[:failed_jp] = "名前は半角英数字でお願いします。"
        flash.now[:failed_en] = "Please input your username using half-width alphanumeric."
        render :oauth_complete
      else
        @user.update(name: name,admit:true)
        log_in @user
        #User.last.delete
        flash["alert_en"] = "You successed to signup."
        flash["alert_jp"] = "会員登録に成功しました。"
        flash["alert_type"] = "success"
        redirect_to "/profile"
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
