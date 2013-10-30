class UsersController < ApplicationController
  authorize_resource
  before_filter :find_user, only: [:show, :ban]

  def show

  end

  def ban
    #@user.banned_at = Time.now
    #@user.save!
  end

  private
  def find_user
    @user = User.includes(:votes).find_by(uid: params[:id])
  end
end

