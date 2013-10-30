class UsersController < ApplicationController
  authorize_resource
  before_filter :find_user, only: [:show]

  def show

  end

  private
  def find_user
    @user = User.includes(:votes).find_by(uid: params[:id])
  end
end

