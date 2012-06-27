# Copyright (c) 2012 Jason McVetta.  This is Free Software, released under the
# terms of the AGPL v3.  See www.gnu.org/licenses/agpl-3.0.html for details.


SALES_TAX_RATE = 0.10  # 10% tax on most sales
IMPORT_TAX_RATE = 0.05 # 5% tax on all imports


#
# Realistically the product catalog, as well as the list tax exempt categories 
# below, would be stored in a database.
#
PRODUCT_CATALOG = {
  # sku = properties
  "10001" => {
    "name" => "Getting the Most Out of Your Asparagus",
    "category" => "book",
    "price" => 12.49,
    "imported" => false,
  },
  "10002" => {
    "name" => "Metalica Sings Christmas Carols",
    "category" => "music",
    "price" => 14.99,
    "imported" => false,
  },
  "10003" => {
    "name" => "Hershey's Chocolate Bar",
    "category" => "food",
    "price" => 0.85,
    "imported" => false,
  },
  "10004" => {
    "name" => "Gordo's Chocolates (box)",
    "category" => "food",
    "price" => 10.00,
    "imported" => true,
  },
  "10005" => {
    "name" => "Eau du Skunk",
    "category" => "cosmetic",
    "price" => 47.50,
    "imported" => true,
  },
  "10006" => {
    "name" => "Le Muskrat",
    "category" => "cosmetic",
    "price" => 27.99,
    "imported" => true,
  },
  "10007" => {
    "name" => "Scent of a Frycook",
    "category" => "cosmetic",
    "price" => 18.99,
    "imported" => false,
  },
  "10008" => {
    "name" => "Uber Asprin",
    "category" => "medical",
    "price" => 9.75,
    "imported" => false,
  },
  "10009" => {
    "name" => "Chocolate Covered Roaches",
    "category" => "food",
    "price" => 11.25,
    "imported" => true,
  },
}

TAX_EXEMPT = [
  "book",
  "medical",
  "food",
]


# An item of merchandise that can be added to the Shopping Cart
class MerchandiseItem

  include Comparable
  
  attr_reader :sku
  attr_reader :name
  attr_reader :category
  attr_reader :price
  attr_reader :imported
  
  def initialize(sku)
    if not PRODUCT_CATALOG.has_key?(sku)
      raise "Sku not found in catalog"
    end
    item = PRODUCT_CATALOG[sku]
    @sku = sku
    @name = item["name"]
    @category = item["category"]
    @price = item["price"]
    @imported = item["imported"]
  end
  
  def <=>(another)
    @sku <=> another.sku
  end
  
  def tax
    tax = 0
    # Import Duty
    if @imported
      tax += @price * 0.05
    end
    # Sales Tax
    if not TAX_EXEMPT.include?(@category)
      tax += @price * 0.10
    end
    return tax.round(2)
  end
  
  def total
    @price + tax
  end
  
  def to_s
    "(%-10s) %-54s: %7s" % [@category, @name, @price]
  end
end

 # A very simple shopping cart
class ShoppingCart 
  def initialize()
    @items = Hash.new(0)
  end
  
  def add(sku, quantity)
    item = MerchandiseItem.new(sku)
    @items[item] += 1
  end
  
  # Sum of pre-tax prices on all items
  def subtotal
    sum = 0
    @items.each_pair { |item, quantity|
      sum += item.price * quantity   
    }
    return sum.round(2)
  end
  
  # Sum of tax on all items
  def tax
    sum = 0
    @items.each_pair { |item, quantity|
      sum += item.tax * quantity   
    }
    return sum.round(2)
  end
  
  def total
    total = subtotal + tax
    return total.round(2)
  end
  
  # Prints receipt
  def receipt
    @items.each_pair { |item, quantity|
      #puts "#{quantity} #{item}"
      puts "%3s %s" % [quantity, item]
    }
  #puts "Sales Taxes: #{tax}"
  puts "-" * 80
  puts "Sales Taxes:                                                             %7s" % tax
  puts "Total:                                                                   %7s" % total
  end
end


def example
  puts "EXAMPLE 1:"
  puts
  cart = ShoppingCart.new
  cart.add("10001", 1)
  cart.add("10002", 1)
  cart.add("10003", 1)
  cart.receipt
  puts
  puts "+" * 80
  puts
  puts "EXAMPLE 2:"
  puts
  cart = ShoppingCart.new
  cart.add("10004", 1)
  cart.add("10005", 1)
  cart.receipt
  puts
  puts "+" * 80
  puts
  puts "EXAMPLE 3:"
  puts
  cart = ShoppingCart.new
  cart.add("10006", 1)
  cart.add("10007", 1)
  cart.add("10008", 1)
  cart.add("10009", 1)
  cart.receipt
  puts
end

example