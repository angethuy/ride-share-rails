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
      redirect_to passengers_path 
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
    last_trip_date = Driver.all[0].trips.last.date
    next_driver = Driver.all[0].id
    Driver.all.each do |x|
      if x.trips.empty?
        next_driver = x.id
        break
      end

      current_last_date = x.trips.last.date
      if x.available && current_last_date < last_trip_date
        last_trip_date = current_last_date
        next_driver = x.id
      end
    end

    trip_info = {
      passenger_id: params[:id],
      driver_id: next_driver,
      date: Date.today,
      cost: rand(1..100)
    }

    @trip = Trip.new(trip_info) 
    @trip.save

    @driver = Driver.find_by(id: next_driver)
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
