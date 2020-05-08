class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])
    if @passenger.nil?
      redirect_to passengers_path
      return
    end
  end

  def new
    @passenger = Passenger.new
  end

  def create
    @passenger = Passenger.new(passenger_params) 

    if @passenger.save #
      redirect_to passengers_path
      return
    else 
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      head :not_found
      return
    elsif @passenger.update(passenger_params)
      redirect_to passenger_path(@passenger.id)
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def destroy
    passenger = Passenger.find_by(id: params[:id])

    if passenger.nil?
      head :not_found
      return
    end

    passenger.destroy

    redirect_to passengers_path
    return
  end

  def active
    @passenger = Passenger.find_by(id: params[:id])

    if !@passenger.trips.empty? && @passenger.trips.last.rating.nil?
      redirect_to passenger_path(@passenger.id)
      return
    end

    passenger = Passenger.find_by(id: params[:id])

    if passenger.nil?
      redirect_to passenger_path
      return
    end

    passenger.is_active = !passenger.is_active
    passenger.save
    redirect_to params[:source_call] == "show" ? passenger_path(passenger.id): passengers_path
  end

  def newtrip
    @passenger = Passenger.find_by(id: params[:id])

    if !@passenger.trips.empty? && @passenger.trips.last.rating.nil?
      redirect_to passenger_path(@passenger.id)
      return
    end

    # find next available driver
    @drivers = Driver.where(:available => true).joins(:trips).order('date DESC').uniq + Driver.where(:available => true).includes(:trips).where(trips: {driver_id: nil}).reverse

    if @drivers.empty?
      redirect_to passenger_path(@passenger.id)
      return
    end

    trip_info = {
      passenger_id: params[:id],
      driver_id: @drivers.last.id,
      date: Date.today,
      cost: rand(1..100)
    }

    @trip = Trip.new(trip_info) 
    @trip.save

    @driver = Driver.find_by(id: @drivers.last.id)
    @driver.available = false
    @driver.save

    if @trip.save && @driver.save
      redirect_to passenger_path(params[:id])
      return
    else 
      render :new, status: :bad_request
      return
    end

  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num, :is_active)
  end

  # TODO - implement strong params
  def trip_params
    return params.require(:trip).permit(:date, :cost, :driver_id, :passenger_id)
  end
end
