require 'date'

class Event
  attr_reader :name, :food_trucks, :date

  def initialize(name)
    @name = name
    @food_trucks = []
    @date = Date.today.strftime("%d/%m/%Y")
  end

  def add_food_truck(food_truck)
    @food_trucks << food_truck
  end

  def food_truck_names
    @food_trucks.map {|truck| truck.name}
  end

  def food_trucks_that_sell(item)
    @food_trucks.find_all {|truck| truck.inventory.include?(item)}
  end

  def total_inventory
    inventory = {}
    get_items.each do |item|
      item_quantity = @food_trucks.sum {|truck| truck.check_stock(item)}
      trucks = food_trucks_that_sell(item)
      inventory[item] = {quantity: item_quantity, food_trucks: trucks}
    end
    inventory
  end

  def get_items
    all_items = []
    @food_trucks.each {|truck| all_items << truck.inventory.keys}
    all_items.flatten.uniq
  end

  def overstocked_items
    overstocked = []
    total_inventory.each do |item, item_qty|
      if item_qty[:quantity] > 50 && item_qty[:food_trucks].length > 1
        overstocked << item
      end
    end
    overstocked
  end

  def sorted_item_list
    get_items.map {|item| item.name}.sort
  end

  def sell(item, quantity)
    return false if !get_items.include?(item)
    return false if total_inventory[item][:quantity] < quantity
    @food_trucks.each do |truck|
      if quantity > truck.check_stock(item)
        quantity -= truck.check_stock(item)
        truck.stock(item, (0 - truck.check_stock(item)))
      else
        truck.stock(item, (0 - quantity))
      end
    end
    true
  end

end
