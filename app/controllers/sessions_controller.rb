class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])

      if @user.activated?
        log_in @user
        flash[:success] = "ログインしました"
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "アカウントが有効化されていません。"
        message += "配信されたメールから有効化を行ってください。"
        flash[:warning] = message
        redirect_to root_url
      end

    else
      flash.now[:danger] = "メールアドレスかパスワードが間違っています。"
      render "new"
    end

  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end



end
