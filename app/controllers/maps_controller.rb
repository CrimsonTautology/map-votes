class MapsController < ApplicationController
  before_filter :authorize, only: [:edit, :update, :vote]
  before_filter :find_map, only: [:show, :edit, :update, :vote]

  def index
    @maps = Map.find(:all, order: 'name')
    @map_types = @maps.group_by {|m| m.map_type}.sort
  end

  def show
    @type = @map.map_type
  end

  def edit
  end

  def update
    if @map.update_attributes(params[:map])
      redirect_to action: 'show', id: @map
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
    @map = Map.find_by_name(params[:id])
  end


end
