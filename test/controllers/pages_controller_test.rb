require "test_helper"

describe PagesController do
  it "must get home" do
    get pages_home_url
    must_respond_with :success
  end

end
