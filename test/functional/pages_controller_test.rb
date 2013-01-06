require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def test_home
    get :home
    assert_response :success
  end

end
