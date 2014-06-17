class CarsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    flash[:notice] = "car was not found"
    redirect_to cars_path
  end
  def index
    @cars = current_user.cars    
  end
  
  def show
    @car = current_user.cars.find(params[:permalink])
  end
  
  def new
    @car = current_user.cars.build    
  end
  
  def create
    @car = current_user.cars.build(car_params)
    if @car.save
      redirect_to car_path(@car), flash: {notice: "new car was created"}
    else
      render "new"
    end
  end
  
  def edit
    @car = Car.find(params[:permalink])
  end
  
  def update
    @car = Car.find(params[:permalink])
    if @car.update(car_params)
      redirect_to cars_path, flash: {notice: "new car was updated"}
    else
      render "edit"
    end
  end
  
  def destroy
    @car = Car.find(params[:permalink])
    @car.destroy
    redirect_to cars_path, flash: {notice: "car was removed"}
  end
  
  private
  
  def car_params
    params.require(:car).permit(:model, :registration_number)
  end
end

