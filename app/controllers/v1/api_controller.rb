module V1
  class ApiController < ApplicationController
    before_filter :check_api_key
    before_filter :check_value, only: [:cast_vote]
    before_filter :check_comment, only: [:write_message]
    before_filter :find_or_create_user_and_map, only: [:cast_vote, :write_message]
    respond_to :json

    def cast_vote
      Vote.cast_vote @user, @map, @value
      head :created
    end

    def write_message
      MapComment.write_message @user, @map, @comment
      head :created
    end
    def server_query
      no_votes = User.where(uid: params["uids"]).where("users.id NOT IN (SELECT user_id from votes where map_id = ?)", @map.id)
      render json: no_votes
    end

    private
    def check_api_key
      api_key = ApiKey.find_by_access_token(params[:access_token])
      head :unauthorized unless api_key
    end

    def find_or_create_user_and_map
      head :bad_request unless params["uid"] and params["map"]
      @user = User.find_by_provider_and_uid("steam", params["uid"]) || User.create_with_steam_id(params["uid"])
      @map = Map.find_or_create_by_name(params["map"])

    end

    def check_value
      @value = params["value"]
      head :bad_request unless @value
    end

    def check_comment
      @comment = params["comment"]
      head :bad_request unless @comment
    end

  end
end
