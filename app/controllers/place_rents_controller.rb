class PlaceRentsController < ApplicationController
  def index
    @place_rents = PlaceRent.all
  end
  
  def show
    @place_rent = PlaceRent.find_by! identifier: params[:identifier]
  end
  
  def new
    @parking = Parking.find(params[:parking_id])
    @place_rent = @parking.place_rents.build
  end
  
  def create
    @parking = Parking.find(params[:parking_id])
    @place_rent = @parking.place_rents.create(place_rent_params)
    if @place_rent.save
      redirect_to place_rents_path, notice: 'new place rent was created'
    else
      render "new"
    end
  end
  
  def edit
    @place_rent = PlaceRent.find_by! identifier: params[:identifier]
  end
  
  def update
    @place_rent = PlaceRent.find_by! identifier: params[:identifier]
    if @place_rent.update
      redirect_to place_rents_path
    else
      render "edit"
    end
  end
  
  def destroy
    @place_rent = PlaceRent.find_by! identifier: params[:identifier]
    @place_rent.destroy
    redirect_to place_rents_path
  end
  
  private
  
  def place_rent_params
    params.require(:place_rent).permit(:start_date, :end_date, :start_date, :end_date, :car_id)
  end
end
