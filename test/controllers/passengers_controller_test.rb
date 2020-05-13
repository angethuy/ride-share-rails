require "test_helper"

describe PassengersController do
  describe "index" do
    it "gives success response for db with 0 passengers" do 
      
    end

    before do
      Passenger.create(name: "Jimothy Jameson", phone_num: "1234567890")
      @passenger = Passenger.first
    end

    it "gives success response for db with many passengers" do
    end

  end

  describe "show" do
    it "retrieves correct passenger" do
    end

    it "redirects accurately for invalid passenger ids" do
    end
  end

  # describe "new" do
  #   # Your tests go here
  # end

  # describe "create" do
  #   # Your tests go here
  # end

  # describe "edit" do
  #   # Your tests go here
  # end

  # describe "update" do
  #   # Your tests go here
  # end

  # describe "destroy" do
  #   # Your tests go here
  # end

  # describe "active" do
  #   # Your tests go here
  # end

  describe "new trip" do
    it "responds with success when creating a trip with valid parameters" do
    end

    it "responds with failure for passengers who are already on trips" do
    end

    it "responds with failure when there are no available drivers" do
    end
  end
end
