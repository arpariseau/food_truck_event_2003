require 'minitest/autorun'
require 'minitest/pride'
require './lib/food_truck'

class FoodTruckTest < MiniTest::Test

  def setup
    @food_truck = FoodTruck.new("Rocky Mountain Pies")
  end

  def test_existence
    assert_instance_of FoodTruck, @food_truck
  end

  def test_attributes
    assert_equal "Rocky Mountain Pies", @food_truck.name
    assert_equal ({}), @food_truck.inventory
  end
end
