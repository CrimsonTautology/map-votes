module V1
  class ApiController < ApplicationController
    before_filter :check_api_key
    before_filter :check_value, only: [:cast_vote]
    before_filter :check_comment, only: [:write_message]
    before_filter :find_or_create_user_and_map, only: [:cast_vote, :write_message]
    respond_to :json

    def cast_vote
      vote = Vote.cast_vote @user, @map, @value
      render json: vote
    end

    def write_message
      map_comment = MapComment.write_message @user, @map, @comment
      render json: map_comment
    end
    def server_query

    end

    private
    def check_api_key
      api_key = ApiKey.find_by_access_token(params[:access_token])
      head :unauthorized unless api_key
    end

    def find_or_create_user_and_map
      head :unauthorized unless params["uid"] and params["map"]
      @user = User.find_by_provider_and_uid("steam", params["uid"]) || User.create_with_steam_id(params["uid"])
      @map = Map.find_or_create_by_name(params["map"])

    end

    def check_value
      @value = params["value"]
      head :unauthorized unless @value
    end

    def check_comment
      @comment = params["comment"]
      head :unauthorized unless @comment
    end

  end
end
