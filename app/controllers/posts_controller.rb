class PostsController < ApplicationController
  before_action :set_post, only: %i[ show ]
  skip_before_action :require_login, only: %i[index]


  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
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

    # 既存の情報を更新するが、main_imagesはattachメソッドで追加する
    if @post.update(post_params.except(:main_images))  # main_images以外を更新
      # 新しい画像が送信されている場合のみattachする
      @post.main_images.attach(params[:post][:main_images]) if params[:post][:main_images].present?

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

  # 複数画像のフォーム内の画像削除のためのアクション
  def destroy_image
    @post = Post.find(params[:post_id])
    image = @post.main_images.find(params[:id])  # ActiveStorage::Attachment を取得

    if image.present?
      image.purge  # 画像のアタッチメントと実際のファイルを削除
      redirect_to edit_post_path(@post), notice: t("flash.images.delete.success")
    else
      redirect_to edit_post_path(@post), alert: t("flash.images.delete.failure")
    end
  end

  # ログインユーザーの一覧
  def my_posts
    @q = current_user.posts.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

  # 検索のオートコンプリート
  def autocomplete
    @posts = Post.where("title LIKE ?", "%#{params[:q]}%").limit(5)
    render partial: "posts/autocomplete_results", locals: { posts: @posts }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body, :thumbnail, main_images: [])
    end
end
