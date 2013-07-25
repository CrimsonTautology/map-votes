class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :admin?

  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin?
    false
  end

  def authorize
    unless admin?
      flash[:error] = "Unauthorized Access"
      redirect_to home_path
      false
    end
  end

end
