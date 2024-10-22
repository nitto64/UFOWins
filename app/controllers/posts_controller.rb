class PostsController < ApplicationController
  before_action :set_post, only: %i[ show ]
  skip_before_action :require_login, only: %i[index]


  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:notice] = t("flash.created", item: Post.model_name.human)
      redirect_to root_path
    else
      flash.now[:alert] = t("flash.not_created", item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      flash[:notice] = t("flash.updated", item: Post.model_name.human)
      redirect_to @post
    else
      flash.now[:alert] = t("flash.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!

    redirect_to root_path, notice: t("flash.deleted", item: Post.model_name.human), status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :thumbnail)
    end
end
