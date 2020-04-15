class FoodTruck
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def stock(item, amount)
    @inventory[item] += amount
  end

  def check_stock(item)
    @inventory[item]
  end

  def potential_revenue
    revenue = 0
    @inventory.each {|item, amount| revenue += item.price * amount}
    revenue
  end

end
