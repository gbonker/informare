require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  should have_many(:issues)
end
