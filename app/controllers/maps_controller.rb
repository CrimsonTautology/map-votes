class MapsController < ApplicationController
  before_filter :authorize_logged_in, only: [:vote]
  before_filter :authorize_admin, only: [:edit, :update]
  before_filter :find_map, only: [:show, :new, :edit, :update, :vote]

  def index
    if params[:map_type_id]
      @maps = Map.includes([:votes]).where(map_type_id: params[:map_type_id]).order(:name).page(params[:page])
    elsif not params[:search].blank?
      #TODO
      @maps = Map.includes([:votes]).order(:name).page(params[:page])
    else
      @maps = Map.includes([:votes]).order(:name).page(params[:page])
    end
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
    @map = Map.includes(:voted_by, :map_type, :map_comments).find_by_name(params[:id])
  end


end
