class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      flash[:notice] = t('flash.user_sessions.create.success')
      redirect_to root_path
    else
      flash.now[:alert] = t('flash.user_sessions.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:notice] = t('flash.user_sessions.destroy.success')
    redirect_to root_path, status: :see_other
  end
end
