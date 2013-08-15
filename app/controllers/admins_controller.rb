class AdminsController < ApplicationController
  before_filter :authorize_admin

  def index
    @admins = User.admins
  end

  def create
    @admin = User.find_by_uid(params[:uid])

    if @admin
      @admin.admin = true
      @admin.save
      flash[:notice] = "Admin Created"
    else
      @admin = User.create_with_steam_id(params[:uid])

      if @admin
        @admin.admin = true
        @admin.save
        flash[:notice] = "Admin Created"
      else
        flash[:alert] = "Invalid SteamId64"
      end
    end

    redirect_to admins_path
  end

  def destroy
    @admin = User.find(params[:uid])
    if @admin.uid == ENV["HEAD_ADMIN_STEAMID64"]
      flash[:alert] = "Cannot not remove head admin"
    else
      @admin.admin = false
    else

    redirect_to admins_path
  end
end
