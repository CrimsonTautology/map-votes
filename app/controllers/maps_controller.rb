class MapsController < ApplicationController
  before_filter :authorize_logged_in, only: [:vote]
  before_filter :authorize_admin, only: [:edit, :update]
  before_filter :find_map, only: [:show, :new, :edit, :update, :vote]

  def index
    @maps = Map.find(:all, order: 'name', include: [:liked_by, :hated_by, :map_type])
    @map_types = @maps.group_by {|m| m.map_type}.sort
  end

  def show
  end

  def new
  end
  def edit
    @map_types = MapType.find(:all, order: 'name')
  end

  def update
    @map.image = params[:map][:image]
    @map.map_type_id = params[:map][:map_type_id]
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

  private
  def find_map
    @map = Map.includes(:liked_by, :hated_by, :map_type, :map_comments).find_by_name(params[:id])
  end


end
