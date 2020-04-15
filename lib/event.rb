class Event
  attr_reader :name, :food_trucks

  def initialize(name)
    @name = name
    @food_trucks = []
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

end
