class ParkingsController < ApplicationController
  layout "admin_layout", only: [:new, :edit]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  skip_before_action :authenticate_account!, :only => [:index, :show]
  
  def not_found
    flash[:notice] = "parking was not found"
    redirect_to parkings_path
  end
  
  def index
    @parkings = Parking.search(params)
  end
  
  def show
    @parking = Parking.find(params[:id])
  end
  
  def new
    @parking = Parking.new
    @parking.build_address
  end
  
  def create
    @owner = current_user
    @parking = @owner.parkings.create(parking_params)
    if @parking.save
      redirect_to parkings_path, flash: {notice: "new parking was created"}
    else
      render "new"
    end
  end
  
  def edit
    @parking = Parking.find(params[:id])
  end
  
  def update
    @parking = Parking.find(params[:id])
    if @parking.update(parking_params)
      redirect_to parkings_path, flash: {notice: "parking was updated"}
    else
      render "edit"
    end
  end
  
  def destroy
    @parking = Parking.find(params[:id])
    @parking.destroy
    redirect_to parkings_path, flash: {notice: "parking was removed"}
  end
  
private
  def parking_params
    params.require(:parking).permit(:kind, :places, :hour_price, :day_price, :address_attributes => [:city, :street, :zip_code])
  end
end

