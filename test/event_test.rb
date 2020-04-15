require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/event'
require './lib/food_truck'
require './lib/item'

class EventTest < MiniTest::Test

  def setup
  @event = Event.new("South Pearl Street Farmers Market")
  @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
  @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
  @food_truck3 = FoodTruck.new("Palisade Peach Shack")
  @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
  @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
  @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
  @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
  @food_truck1.stock(@item1, 35)
  @food_truck1.stock(@item2, 7)
  @food_truck2.stock(@item3, 25)
  @food_truck2.stock(@item4, 50)
  @food_truck3.stock(@item1, 65)
  @food_truck3.stock(@item3, 10)
  end

  def test_existence
    assert_instance_of Event, @event
  end

  def test_attributes
    assert_equal "South Pearl Street Farmers Market", @event.name
    assert_equal [], @event.food_trucks
  end

  def test_add_food_truck
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal [@food_truck1, @food_truck2, @food_truck3], @event.food_trucks
  end

  def test_food_truck_names
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal ["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"], @event.food_truck_names
  end

  def test_food_trucks_that_sell
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal [@food_truck1, @food_truck3], @event.food_trucks_that_sell(@item1)
    assert_equal [@food_truck2], @event.food_trucks_that_sell(@item4)
  end

  def test_total_inventory
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    item1_quantity = {quantity: 100, food_trucks: [@food_truck1, @food_truck3]}
    item2_quantity = {quantity: 7, food_trucks: [@food_truck1]}
    item3_quantity = {quantity: 35, food_trucks: [@food_truck2, @food_truck3]}
    item4_quantity = {quantity: 50, food_trucks: [@food_truck2]}
    expected = {@item1 => item1_quantity, @item2 => item2_quantity,
                @item3 => item3_quantity, @item4 => item4_quantity}
    assert_equal expected, @event.total_inventory
  end

  def test_get_items
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal [@item1, @item2, @item3, @item4], @event.get_items
  end

  def test_overstocked_items
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal [@item1], @event.overstocked_items
  end

  def test_sorted_item_list
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal ["Apple Pie (Slice)", "Banana Nice Cream",
         "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"], @event.sorted_item_list
  end

  def test_date
    Date.stubs(:today).returns(Date.new(2020, 02, 24))
    date_event = Event.new("South Pearl Street Farmers Market")
    assert_equal "24/02/2020", date_event.date
  end

  def test_sell
    item5 = Item.new({name: 'Onion Pie', price: '$25.00'})
    @event.add_food_truck(@food_truck1)
    @event.add_food_truck(@food_truck2)
    @event.add_food_truck(@food_truck3)
    assert_equal false, @event.sell(@item1, 200)
    assert_equal false, @event.sell(item5, 1)
    assert_equal true, @event.sell(@item4, 5)
    assert_equal 45, @food_truck2.check_stock(@item4)
    assert_equal true, @event.sell(@item1, 40)
    assert_equal 0, @food_truck1.check_stock(@item1)
    assert_equal 60, @food_truck3.check_stock(@item1)
  end

end
