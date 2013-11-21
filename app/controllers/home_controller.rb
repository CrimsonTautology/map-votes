class HomeController < ApplicationController
  def index
    votes = Vote.order(updated_at: :desc).first(20)
    comments = MapComment.order(created_at: :desc).first(20)
    maps = Map.order(created_at: :desc).first(20)
    all = (votes + comments + maps).sort{|x,y| x.created_at <=> y.created_at}.reverse.take(30)
    @events = Event.build_list all
  end
end
