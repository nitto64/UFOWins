class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = t("flash.updated", item: User.model_name.human)
      redirect_to profile_path
    else
      flash.now[:alert] = t("flash.not_updated", item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:notice] = t("flash.deleted", item: User.model_name.human)
      redirect_to root_path
    else
      flash[:alert] = t("flash.not_deleted", item: User.model_name.human)
      redirect_to profile_path
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name) # `name` のみ編集対象
  end
end
