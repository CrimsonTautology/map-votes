class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :current_user_admin?

  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user_admin?
    current_user and @current_user.admin?
  end

  def authorize_admin
    unless current_user_admin?
      flash[:error] = "Unauthorized Access"
      redirect_to root_path
      false
    end
  end

  def authorize_logged_in
    unless current_user
      flash[:error] = "Not Logged in"
      redirect_to root_path
      false
    end
  end

end
