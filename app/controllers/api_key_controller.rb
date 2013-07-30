class ApiKeyController < ApplicationController
  before_filter :authorize_admin
  def index
    @api_keys = ApiKey.find(:all)
  end

  def create
    @api_key = ApiKey.new(params[:api_key])

    if @api_key.save
      flash[:notice] = "New Key Added"
    else
      flash[:alert] = "Could not add key"
    end
    render action: :index
  end

  def destroy
    ApiKey.find(params[:id]).destroy
    flash[:notice] = "Key Deleted!"
    render action: :index
  end
end
