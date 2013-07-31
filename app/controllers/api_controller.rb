class ApiController < ApplicationController
  before_filter :check_api_key
  before_filter :find_or_create_user_and_map, only: [:cast_vote, :write_message]
  respond_to :json

  def cast_vote
    Vote.cast_vote @user, @map, params["value"]
  end

  def write_message
    MapComment.write_message @user, @map, params["comment"]
  end
  def server_query

  end

  private
  def check_api_key
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

  def find_or_create_user_and_map
    @user = User.find_by_provider_and_uid("steam", params["uid"]) || User.create_with_steam_id(params["uid"])
    @map = Map.find_or_create_by_name(params["map"])

  end

end
