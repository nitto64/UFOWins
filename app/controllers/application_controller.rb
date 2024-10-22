class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :require_login

  private

  def not_authenticated
    flash[:alert] = t("flash.require_login")
    redirect_to login_path
  end
end
