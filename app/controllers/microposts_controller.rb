class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :create, :destroy, :favorite]
  before_action :correct_user, only: :destroy

  def index
    @comment = current_user.comments.build
    if params[:search].blank?
      flash[:danger] = "検索ワードを入力してください。"
      redirect_to request.referrer || root_url
    else
      @microposts = Micropost.search(params[:search]).paginate(page: params[:page])
    end
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comment = current_user.comments.build
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @micropost = current_user.microposts.build
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render "microposts/new"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
