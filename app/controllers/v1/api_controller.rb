require "base64"

module V1
  class ApiController < ApplicationController
    authorize_resource class: false
    before_filter :check_value, only: [:cast_vote]
    before_filter :check_comment, only: [:write_message]
    before_filter :check_map, only: [:cast_vote, :write_message, :favorite, :unfavorite, :have_not_voted, :update_map_play_time]
    before_filter :check_user, only: [:cast_vote, :write_message, :favorite, :unfavorite, :get_favorites]
    respond_to :json

    def cast_vote
      Vote.cast_vote @user, @map, @value

      out = {
        player: params[:player].to_i,
        value: @value.to_i,
        command: "cast_vote"
      }
      render json: out
    end

    def write_message
      MapComment.write_message @user, @map, @comment
      head :created
    end
    def server_query
    end

    def favorite
      MapFavorite.favorite @user, @map

      out = {
        player: params[:player].to_i,
        favorite: true,
        map: @map.name,
        command: "favorite"
      }
      render json: out
    end

    def unfavorite
      MapFavorite.unfavorite @user, @map

      out = {
        player: params[:player].to_i,
        favorite: false,
        map: @map.name,
        command: "unfavorite"
      }
      render json: out
    end

    def get_favorites
      head :bad_request and return unless params[:player]

      out = {
        maps: @user.map_favorites.map{|m| m.map.name},
        player: params[:player].to_i,
        command: "get_favorites"
      }
      render json: out
    end

    def have_not_voted
      head :bad_request and return unless params[:uids]
      head :bad_request and return unless params[:players]
      uids = User.where(uid: params[:uids]).where("users.id NOT IN (SELECT user_id from votes where map_id = ?)", @map).map(&:uid)

      #Build the found players array which is parrel to the params["uid"] array - the uids that have not voted
      players = []
      uids.each do |uid|
        i = params[:uids].index(uid) 
        players << params[:players][i].to_i
      end
      out = {
        players: players,
        uids: uids,
        command: "have_not_voted"
      }
      render json: out
    end

    def update_map_play_time
      head :bad_request and return unless params[:time_played]
      head :bad_request and return unless (1..86400000).include?(params[:time_played].to_i)
      @map.update_play_time params[:time_played].to_i
      head :ok
    end

    private
    def check_api_key
      api_key = ApiKey.authenticate(params[:access_token])
      head :unauthorized unless api_key
    end

    def check_map
      head :bad_request unless params["map"]
      @map = Map.find_or_create_by(name: params["map"])
      head :bad_request unless @map
    end

    def check_user
      head :bad_request unless params["uid"]
      @user = User.find_by(provider: "steam", uid: params["uid"]) || User.create_with_steam_id(params["uid"])
      head :bad_request unless @user
    end

    def check_value
      @value = params["value"]
      head :bad_request unless @value
    end

    def check_comment
      @comment = params["comment"]
      if params["base64"]
        @comment = Base64.urlsafe_decode64 @comment
      end
      head :bad_request unless @comment
    end

  end
end
