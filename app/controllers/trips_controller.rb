class TripsController < ApplicationController
  def show
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    end 
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    elsif @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def archive
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      redirect_to trip_path
      return
    end

    trip.is_archive = !trip.is_archive
    trip.save
    redirect_to trip_path(trip.id)
  end

  private

  def trip_params
    return params.require(:trip).permit(:rating, :is_archive)
  end
end
