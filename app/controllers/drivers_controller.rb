class DriversController < ApplicationController

  def self.any_available?
    return !Driver.where(:available => true).empty?
  end

  def index
    @drivers = Driver.all
  end

  def show
    @driver = Driver.find_by(id: params[:id])
    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params) 
    @driver.available = true

    if @driver.save #
      redirect_to drivers_path
      return
    else 
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to drivers_path 
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def destroy
    driver = Driver.find_by(id: params[:id])

    if driver.nil?
      head :not_found
      return
    end

    driver.destroy

    redirect_to drivers_path
    return
  end


  # TODO: consider combining active and available by passing in additional params
  # TODO: switch to update instead of save?
  
  def active
    driver = Driver.find_by(id: params[:id])

    if driver.nil?
      redirect_to driver_path
      return
    end

    # prevents drivers from being available while deactivated
    driver.available = !driver.is_active
    driver.is_active = !driver.is_active

    driver.save
    redirect_to params[:source_call] == "show" ? driver_path(driver.id): drivers_path
  end

  def available
    driver = Driver.find_by(id: params[:id])

    if driver.nil?
      redirect_to driver_path
      return
    end

    driver.available = !driver.available
    driver.save
    redirect_to drivers_path
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
