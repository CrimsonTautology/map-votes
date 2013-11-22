class UsersController < ApplicationController
  authorize_resource
  before_filter :find_user, only: [:show, :ban, :edit, :unban, :update]

  def show
    authorize! :read, @user

  end

  def edit
  end
  def update
    @user.admin = params[:user][:admin]
    @user.moderator = params[:user][:moderator]
    if @user.save
      redirect_to(@user)
    else
      flash[:alert] = "Could not update user"
      render action: 'edit'
    end

  end
  def ban
    if !@user.banned?
      @user.banned_at = Time.now
      @user.save!
      flash[:notice] = "Banned User"
    else
      flash[:alert] = "User already banned"

    end
    redirect_to(@user)
  end
  def unban
    @user.banned_at = nil
    @user.save!
    flash[:notice] = "Unbanned User"
    redirect_to(@user)
  end

  private
  def find_user
    @user = User.includes(:votes).find_by(uid: params[:id])
  end
end

