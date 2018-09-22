class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers, :change_password]
  before_action :correct_user, only: [:edit, :update, :change_password]
  before_action :admin_user, only: :destroy

  def new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find_by(id: params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render "new"
    end

  end

  def edit
    @page_title = "プロフィールの編集"
    @partial = "edit_form"
  end

  def update

    if params[:origin_form] == "change_password"
      if params[:user][:password].blank?
        flash.now[:danger] = "パスワードを入力してください"
        @partial = "change_password_form"
        render "edit"
        return
      end
    end

    if @user.update_attributes(user_params)
      flash[:success] = "変更を保存しました"
      redirect_to @user
    else
      if params[:origin_form] == "edit"
        @partial = "edit_form"
      else
        @partial = "change_password_form"
      end
      render "edit"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def change_password
    @page_title = "パスワードの変更"
    @partial = "change_password_form"
    render "edit"
  end

  def facebook_login

    facebook_params = request.env['omniauth.auth']

    @user = User.from_omniauth(facebook_params)
    if @user.save
      log_in @user
      @user.activate
      remember(@user)
      flash[:success] = "Facebookアカウントでログインしました"
      redirect_to @user
    else
      flash[:danger] = "Facebookアカウントでのログインに失敗しました"
      redirect_to auth_failure_path
    end

    def auth_failure
      redirect_to root_url
    end

  end

  private

    def user_params
      params.require(:user).permit(:full_name, :name, :email, :password,
                                   :password_confirmation, :website,
                                   :self_introduction, :telephone_number,
                                   :gender)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end


end
