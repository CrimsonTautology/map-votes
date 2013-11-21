class MapsController < ApplicationController
  authorize_resource
  before_filter :find_map, only: [:show, :new, :edit, :update, :vote, :favorite, :unfavorite]

  def index
    @maps = Map.filter(params).paginate(page: params[:page], per_page: 32)
    @map_types = MapType.order(:name)
  end

  def show
    @map_comments = @map.map_comments.order('created_at DESC')
  end

  def new
  end
  def edit
    @map_types = MapType.order(:name)
  end

  def update
    @map.image = params[:map][:image]
    @map.map_type_id = params[:map][:map_type_id]
    @map.origin = params[:map][:origin]
    @map.description = params[:map][:description]
    if @map.save
      redirect_to(@map)
    else
      flash[:alert] = "Could not update map"
      render action: 'edit'
    end
  end

  def vote
    value =  0
    value =  1 if params[:type] == "up"
    value = -1 if params[:type] == "down"
    Vote.cast_vote current_user, @map, value
    redirect_to :back, notice: "Thank you for voting!"
  end

  def favorite
    MapFavorite.favorite current_user, @map
    redirect_to :back, notice: "Added to favorites"
  end

  def unfavorite
    MapFavorite.unfavorite current_user, @map
    redirect_to :back, notice: "Removed from favorites"
  end

  private
  def find_map
    @map = Map.includes(:voted_by, :map_type, :map_comments).find_by(name: params[:id])
  end


end
