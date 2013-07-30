class ApiKeysController < ApplicationController
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
    redirect_to api_keys_path
  end

  def destroy
    ApiKey.find(params[:id]).destroy
    flash[:notice] = "Key Deleted!"
    redirect_to api_keys_path
  end
end
