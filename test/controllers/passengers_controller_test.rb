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

    it "will redirect and flash error if passenger active state change attempt is made during rides" do
      # status = @passenger.is_active
      patch passenger_active_path(@passenger.id)
      must_redirect_to passenger_path(@passenger.id)
      # expect(@passenger.is_active).must_equal status
      assert_equal "Cannot change status while Ada Lovelace has a trip in progress! Please <a href=\"/trips/#{@trip.id}/edit\">rate Trip #{@trip.id}</a>", flash[:danger]
    end

    it "will redirect and flash success on valid passenger active state change" do
      # status = Passenger.last.is_active
      passenger = Passenger.last
      patch passenger_active_path(passenger.id)
      must_redirect_to passengers_path
      assert_equal "Successfully deactivated #{passenger.name}.", flash[:success]
      # expect(Passenger.last.is_active).must_equal !status
    end
  end

  describe "new trip" do

    before do
      Passenger.create(name: "Big Bird", phone_num: "1800yellowbirb")
      post drivers_path, params: { driver: { name: "minnie mouse", vin: "it's minnie"}}
      @passenger = Passenger.last
      @driver = Driver.last
    end

    it "will redirect and flash success when creating a trip for a valid passenger and available driver" do
      expect(@driver.available).must_equal true
      patch passenger_new_trip_path(@passenger.id)
      must_redirect_to passenger_path(@passenger.id)
      trip = Trip.last
      assert_equal "Successfully created <a href=\"/trips/#{trip.id}\">new trip ##{trip.id}</a>", flash[:success]
    end

    it "redirects and responds with failure for passengers who are already on trips" do
      expect(@driver.available).must_equal true
      patch passenger_new_trip_path(@passenger.id)
      expect(@passenger.has_inprogress_trip?).must_equal true
      patch passenger_new_trip_path(@passenger.id)
      must_redirect_to passenger_path(@passenger.id)
      assert_equal "Passenger is already on a trip.", flash[:danger]  
    end

    it "responds with failure when there are no available drivers" do
      patch passenger_new_trip_path(@passenger.id)
      expect(Driver.get_next_available).must_equal nil
      Passenger.create(name: "Hush Puppy", phone_num: "hushhushbork")
      patch passenger_new_trip_path(Passenger.last.id)
      must_redirect_to passenger_path(Passenger.last.id)
      assert_equal "There are currently no drivers available for new trips.", flash[:danger] 
    end
  end
end


