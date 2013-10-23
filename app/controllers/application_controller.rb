class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :current_user_admin?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message, status: 403
  end

  private
  
  def current_ability
    @current_ability ||= Ability.new(current_user, params[:access_token])
  end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
