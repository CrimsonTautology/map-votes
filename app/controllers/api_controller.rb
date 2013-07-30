class ApiController < ApplicationController
  before_filter :check_api_key
  respond_to :json

  private
  def check_api_key
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
end
