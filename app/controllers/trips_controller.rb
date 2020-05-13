class TripsController < ApplicationController
  def show
    session[:return_to] = request.referer
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
      
      # flips driver back to available after trip has been completed
      if !@trip.rating.nil?
        @driver = Driver.find_by(id: @trip.driver_id)
        @driver.update({available: true})
      end
      redirect_to trip_path(@trip.id)
      flash[:success] = "Trip successfully rated."
      return
    else 
      render :edit, status: :bad_request 
      return
    end
  end

  def destroy
    trip = Trip.find_by(id: params[:id])

    if trip.nil?
      head :not_found
      return
    end

    if trip.rating.nil?
      driver = Driver.find_by(id: trip.driver_id)
      driver.update({available: true})
    end

    trip.destroy
    flash[:success] = "Successfully deleted trip ##{trip.id}"
    # https://stackoverflow.com/questions/2139996/how-to-redirect-to-previous-page-in-ruby-on-rails
    redirect_to session.delete(:return_to)
    return
  end

  private

  def trip_params
    return params.require(:trip).permit(:rating)
  end
end
