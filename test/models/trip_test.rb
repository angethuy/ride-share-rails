require "test_helper"

describe Trip do
  before do
    Passenger.create(name: "Chihiro Ogino", phone_num: "089-381-5839")
    Driver.create(name: "Haku", vin: "river-dragon")
  end

  let (:new_trip) {
    Trip.new(passenger_id: Passenger.all[0].id,
            driver_id: Driver.all[0].id, 
            date: Date.today,
            cost: 100)
  }

  it "can be instantiated" do
    expect(new_trip.valid?).must_equal true
  end

  it "will have the required fields" do
    new_trip.save
    trip = Trip.first

    [:passenger_id, :driver_id, :date, :cost, :rating].each do |field|
      expect(trip).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have one driver" do
      new_trip.save
      expect(new_trip.driver_id).must_be_kind_of Integer
    end

    it "can have one passenger" do
      new_trip.save
      expect(new_trip.passenger_id).must_be_kind_of Integer
    end
  end

  describe "validations" do
    it "must have rating greater than 0" do
      new_trip.rating = 0

      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["must be greater than 0"]
    end

    it "must have rating less than 6" do
      new_trip.rating = 6

      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["must be less than 6"]
    end

    it "must be an integer" do
      new_trip.rating = 1.4

      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["must be an integer"]
    end
  end

  # # Tests for methods you create should go here
  # describe "custom methods" do
  #   # Your tests here
  # end
end
