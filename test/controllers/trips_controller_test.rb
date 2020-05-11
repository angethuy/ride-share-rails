require "test_helper"
require 'pry'

describe TripsController do
  before do
    Passenger.create(name: "Mei Kusakabe", phone_num: "089-381-5839")
    Driver.create(name: "Totoro", vin: "death-god")

    trip_hash = {
      passenger_id: Passenger.all[0].id,
      driver_id: Driver.all[0].id, 
      date: Date.today,
      cost: 100
    }

    trip = Trip.new(trip_hash)
    trip.save
  end

  describe "show" do
    before do
      @trip = Trip.first
    end

    it "responds with success when showing an existing valid trip" do
      # Ensure that there is a trip saved
      valid_trip_id = @trip.id
      get "/trips/#{valid_trip_id}"
      must_respond_with :success
    end

    it "responds with not found 404 with an invalid trip id" do
      invalid_trip_id = 999
      get "/trips/#{invalid_trip_id}"
      must_respond_with :not_found
    end
  end

  describe "edit" do
    # Passenger.create(name: "Satsuki Kusakabe", phone_num: "089-381-5839")
    # Driver.create(name: "Catbus", vin: "death-ferry")

    # edit_trip_hash: = {
    #   passenger_id: Passenger.all[1].id,
    #   driver_id: Driver.all[1].id, 
    #   date: Date.today,
    #   cost: 200
    # }

    # trip = Trip.new(trip_hash)
    # trip.save

    it "responds with success when getting the edit page for an existing, valid trip" do
      id = Trip.first.id
      get "/trips/#{id}/edit"

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      id = -1
      get "/trips/#{id}/edit"

      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:update_trip_hash) {
      {
        trip: {
          rating: 3
        }
      }
    }

    it "can update an existing trip with valid information accurately, and redirect" do
      id = Trip.last.id
      expect {
        patch trip_path(id), params: update_trip_hash
      }.wont_change "Trip.count"
  
      must_respond_with :redirect
      trip = Trip.find_by(id: id)

      expect(trip.rating).must_equal 3
    end

    it "does not update any trip if given an invalid id, and responds with a 404" do
      id = -1

      expect {
        patch trip_path(id), params: update_trip_hash
      }.must_differ "Trip.count", 0

      must_respond_with :not_found
    end

    it "does not create a trip if the form data violates Trip validations (exceeds 5), and responds with a redirect" do
      update_trip_hash[:trip][:rating] = 6
      id = Trip.first.id

      expect {
        patch trip_path(id), params: update_trip_hash
      }.must_differ "Trip.count", 0

      must_respond_with :bad_request
    end

    it "does not create a trip if the form data violates Trip validations (is a 0), and responds with a redirect" do
      update_trip_hash[:trip][:rating] = 0
      id = Trip.first.id

      expect {
        patch trip_path(id), params: update_trip_hash
      }.must_differ "Trip.count", 0

      must_respond_with :bad_request
    end

    it "does not create a trip if the form data violates Trip validations (is a letter), and responds with a redirect" do
      update_trip_hash[:trip][:rating] = "two"
      id = Trip.first.id

      expect {
        patch trip_path(id), params: update_trip_hash
      }.must_differ "Trip.count", 0

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    let (:destroy_trip_hash) {
      {
        trip: {
          rating: 3
        },
      }
    }

    it "destroys the trip instance in db when trip exists, then redirects" do
      id = Trip.first.id
      expect {
        delete trip_path(id), params: destroy_trip_hash
      }.must_differ "Trip.count", -1
  
      must_respond_with :redirect
    end

    it "does not change the db when the trip does not exist, then responds with " do
      id = -1
      expect {
        delete trip_path(id), params: destroy_trip_hash
      }.must_differ "Trip.count", 0
  
      must_respond_with :not_found
    end
  end
end
