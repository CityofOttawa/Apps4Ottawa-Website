require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "#can_submit_ideas_apps? returns if the user can submit an app or idea" do
    u = User.new
    assert !u.can_submit_ideas_apps?
    
    u.update_attributes(:street_address => "A street address",
                        :city => "A city",
                        :province => "A province",
                        :postal_code => "A postal code")
    assert u.can_submit_ideas_apps?
  end
end
