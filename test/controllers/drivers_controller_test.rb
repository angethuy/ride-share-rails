require "test_helper"

describe DriversController do
  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Ensure that there is at least one Driver saved
      Driver.create(name: "Princess Lusheeta", vin: "castle-in-the-sky")

      get "/drivers"
      must_respond_with :success   
    end

    it "responds with success when there are no drivers saved" do
      # Ensure that there are zero drivers saved
      get "/drivers"
      must_respond_with :success
    end
  end

  before do
    Driver.create(name: "Sheeta", vin: "mountain-gril")
    @driver = Driver.first
  end

  describe "show" do
    it "responds with success when showing an existing valid driver" do
      # Ensure that there is a driver saved
      valid_driver_id = @driver.id
      get "/drivers/#{valid_driver_id}"
      must_respond_with :success
    end

    it "responds with redirection 302 with an invalid driver id" do
      invalid_driver_id = 999
      get "/drivers/#{invalid_driver_id}"
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "responds with success" do
      get new_driver_path

      must_respond_with :success
    end
  end

  describe "create" do
    let (:driver_hash) {
      {
        driver: {
          name: "Coal Miner Pazu",
          vin: "trumpet-boy",
        }
      }
    }

    it "can create a new driver with valid information accurately, and redirect" do
      expect {
        post drivers_path, params: driver_hash
      }.must_differ 'Driver.count', 1
  
      must_respond_with  :redirect
      must_redirect_to drivers_path
      expect(Driver.last.name).must_equal driver_hash[:driver][:name]
      expect(Driver.last.vin).must_equal driver_hash[:driver][:vin]
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      driver_hash[:driver][:name] = nil

      expect {
        post drivers_path, params: driver_hash
      }.must_differ "Driver.count", 0

      must_respond_with :bad_request
    end
  end
  
  describe "edit" do
    let (:edit_driver_hash) {
      {
        driver: {
          name: "Hero Pazu",
          vin: "spell-boy",
        },
      }
    }

    it "responds with success when getting the edit page for an existing, valid driver" do
      id = Driver.first.id
      get "/drivers/#{id}/edit"

      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do
      id = -1
      get "/drivers/#{id}/edit"

      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:new_driver_hash) {
      {
        driver: {
          name: "Coal Miner Pazu",
          vin: "flying-boy",
        },
      }
    }

    it "can update an existing driver with valid information accurately, and redirect" do
      id = Driver.first.id
      expect {
        patch driver_path(id), params: new_driver_hash
      }.wont_change "Driver.count"
  
      must_respond_with :redirect
  
      driver = Driver.find_by(id: id)
      expect(driver.name).must_equal new_driver_hash[:driver][:name]
      expect(driver.vin).must_equal new_driver_hash[:driver][:vin]
    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      id = -1

      expect {
        patch driver_path(id), params: new_driver_hash
      }.must_differ "Driver.count", 0

      must_respond_with :not_found
    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      new_driver_hash[:driver][:name] = nil
      id = Driver.first.id

      expect {
        patch driver_path(id), params: new_driver_hash
      }.must_differ "Driver.count", 0

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    let (:destroy_driver_hash) {
      {
        driver: {
          name: "Pirate Pazu",
          vin: "gunner-boy",
        },
      }
    }

    it "destroys the driver instance in db when driver exists, then redirects" do
      id = Driver.first.id
      expect {
        delete driver_path(id), params: destroy_driver_hash
      }.must_differ "Driver.count", -1
  
      must_respond_with :redirect
    end

    it "does not change the db when the driver does not exist, then responds with " do
      id = -1
      expect {
        delete driver_path(id), params: destroy_driver_hash
      }.must_differ "Driver.count", 0
  
      must_respond_with :not_found
    end
  end
end
