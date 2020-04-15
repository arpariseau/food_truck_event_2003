require 'minitest/autorun'
require 'minitest/pride'
require './lib/food_truck'
require './lib/item'

class FoodTruckTest < MiniTest::Test

  def setup
    @food_truck = FoodTruck.new("Rocky Mountain Pies")
    @item1 = Item.new({name: 'Peach Pie (Slice)', price: '$3.75'})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
  end

  def test_existence
    assert_instance_of FoodTruck, @food_truck
  end

  def test_attributes
    assert_equal "Rocky Mountain Pies", @food_truck.name
    assert_equal ({}), @food_truck.inventory
  end

  def test_stock
    @food_truck.stock(@item1, 30)
    expected1 = {@item1 => 30}
    assert_equal expected1, @food_truck.inventory
    @food_truck.stock(@item1, 25)
    expected2 = {@item1 => 55}
    assert_equal expected2, @food_truck.inventory
    @food_truck.stock(@item2, 12)
    expected3 = {@item1 => 55, @item2 => 12}
    assert_equal expected3, @food_truck.inventory
  end

  def test_check_stock
    assert_equal 0, @food_truck.check_stock(@item1)
    @food_truck.stock(@item1, 30)
    assert_equal 30, @food_truck.check_stock(@item1)
    @food_truck.stock(@item1, 25)
    assert_equal 55, @food_truck.check_stock(@item1)
  end

end
