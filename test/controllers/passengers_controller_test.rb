require "test_helper"

describe PassengersController do
  describe "index" do
    it "gives success response for db with 0 passengers" do 
      get "/passengers"
      must_respond_with :success  
    end

    before do
      Passenger.create(name: "Jimothy Jameson", phone_num: "1234567890")
      @passenger = Passenger.first
    end

    it "gives success response for db with many passengers" do
      get "/drivers"
      must_respond_with :success   
    end

  end

  describe "show" do

    before do
      Passenger.create(name: "Picchu Cakes", phone_num: "1800doggo")
      @passenger = Passenger.first
    end

    it "gives success response for finding a passenger with valid id" do
      get "/passengers/#{@passenger.id}"
      must_respond_with :success
    end

    it "redirects accurately for invalid passenger ids" do
      get "/passengers/potato"
      must_redirect_to passengers_path
    end
  end

  describe "new" do
    it "responds with success" do
      get new_passenger_path
      must_respond_with :success
    end
  end

  describe "create" do
    let (:passenger_hash) {
      {
        passenger: {
          name: "Finn",
          phone_num: "fishyfish",
        }
      }
    }

    it "responds with success when adding a valid passenger" do 

      expect {
        post passengers_path, params: passenger_hash
      }.must_differ "Passenger.count", 1
      
      must_redirect_to passengers_path
    end



    it "responds with error when adding invalid passenger" do
      passenger_hash[:passenger][:name] = nil

      expect {
        post passengers_path, params: passenger_hash
      }.must_differ "Driver.count", 0

      must_respond_with :bad_request
    end

  end

  describe "edit" do

    before do
      Passenger.create(name: "Tater Tot", phone_num: "lil-hamster-2948d")
      @passenger = Passenger.first
    end

    it "responds with success when getting the edit page for an existing, valid driver" do
      get "/passengers/#{@passenger.id}/edit"
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      id = -1
      get "/passengers/#{id}/edit"

      must_respond_with :not_found
    end

  end

describe "update" do
  before do
    Passenger.create(name: "Elvy Alien Cat", phone_num: "meow-from-space")
    @passenger = Passenger.first
  end

    let (:update_passenger_hash) {
      {
        passenger: {
          name: "Elvy Super Alien Cyat",
          phone_num: "MEOwwwwOW",
        },
      }
    }

    it "updates an existing passenger and redirects accurately" do
      id = @passenger.id
      expect {
        patch passenger_path(id), params: update_passenger_hash
      }.wont_change "Passenger.count"
  
      must_respond_with :redirect
  
      passenger = Passenger.find_by(id: id)

      expect(passenger.name).must_equal update_passenger_hash[:passenger][:name]
      expect(passenger.phone_num).must_equal update_passenger_hash[:passenger][:phone_num]
    end

    it "does not save data when updating invalid passenger, and responds with a 404" do
      expect {
        patch passenger_path("bajillions"), params: update_passenger_hash
      }.must_differ "Passenger.count", 0

      must_respond_with :not_found
    end

    it "does not update a passenger using bad data, and responds with a redirect" do
      update_passenger_hash[:passenger][:name] = nil
      id = Passenger.first.id

      expect {
        patch passenger_path(id), params: update_passenger_hash
      }.must_differ "Driver.count", 0

      must_respond_with :bad_request

      
    end
  end

  describe "destroy" do
    before do
      Passenger.create(name: "Coco the kitty", phone_num: "fluffyfluffs")
      @passenger = Passenger.first
    end
    it "removes a valid passenger from db, then redirects" do
      id = @passenger.id
      expect {
        delete passenger_path(id)
      }.must_differ "Passenger.count", -1
  
      must_redirect_to passengers_path
    end

    it "doesn't change db with destroying invalid passenger, and responds with error" do
      expect {
        delete passenger_path("XVII")
      }.must_differ "Passenger.count", 0
  
      must_respond_with :not_found
    end
  end

 

  describe "active" do
    
    before do
      Passenger.create(name: "Ada Lovelace", phone_num: "938-392-9394")
      Driver.create(name: "Cookie Monster", vin: "crumbynoms")
  
      @passenger = Passenger.first
      @driver = Driver.first
  
      trip_hash = {
        passenger_id: @passenger.id,
        driver_id: @driver.id, 
        date: Date.today,
        cost: 1
      }
  
      @trip = Trip.create(trip_hash)
  
      Passenger.create(name: "Sugar Bear", phone_num: "111-333-4444")
  
    end

    it "will not toggle the active status of a passenger who's on a ride" do
      status = @passenger.is_active
      patch passenger_active_path(@passenger.id)
      must_redirect_to passenger_path(@passenger.id)
      expect(@passenger.is_active).must_equal status
    end

    it "will toggle active status of a passenger who's not on a ride" do
      status = Passenger.last.is_active
      patch passenger_active_path(Passenger.last.id)
      must_redirect_to passengers_path
      expect(Passenger.last.is_active).must_equal !status
    end
  end



  describe "new trip" do
    before do
      Passenger.create(name: "Big Bird", phone_num: "1800yellowbirb")
      Driver.create(name: "Mickey Mouse", vin: "hey-its-mickey")
      Driver.create(name: "Minnie Mouse", vin: "3984jdldd")
      Driver.create(name: "Mickey Mouse", vin: "djf30kdjf")
    end

    it "adds a trip to the database" do
    #   passenger = Passenger.last
    #   expect(Driver.count).must_equal 3
    #   patch passenger_new_trip_path(passenger.id)
      
     

    # # expect { 
    # #    patch passenger_new_trip_path(passenger.id)
    # # }.must_differ "passenger.trips.count", 1
    # must_redirect_to root_path
    # #  must_redirect_to passenger_path(passenger.id)
    # # #  expect(passenger.name).must_equal "Big Bird"
    end

    it "responds with failure for passengers who are already on trips" do

    end

    it "responds with failure when there are no available drivers" do
    end
  end
end


