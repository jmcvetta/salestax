# Copyright (c) 2012 Jason McVetta.  This is Free Software, released under the
# terms of the AGPL v3.  See www.gnu.org/licenses/agpl-3.0.html for details.


# Input 1:
# 1 book at 12.49
# 1 music CD at 14.99
# 1 chocolate bar at 0.85
# 
# Input 2:
# 1 imported box of chocolates at 10.00
# 1 imported bottle of perfume at 47.50
# 
# Input 3:
# 1 imported bottle of perfume at 27.99
# 1 bottle of perfume at 18.99
# 1 packet of headache pills at 9.75
# 1 box of imported chocolates at 11.25

TAX_EXEMPT = [
  "book",
  "medical",
  "food",
]

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
    "category" => "cd",
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

class MerchandiseItem
  def initialize(sku, quanitty)
    if not PRODUCT_CATALOG.has_key(sku)
      raise "Sku not found in catalog"
    end
    item = PRODUCT_CATALOG[sku]
    @sku = sku
    @category = item["category"]
    @price = item["price"]
    @imported = item["imported"]
  end
  
  def taxPerItem
    tax = 0
    # Import Duty
    if @imported
      tax += @price * 0.05
    end
    # Sales Tax
    if not TAX_EXEMPT.include?(@category)
      tax += @price * 0.10
    end
    return tax
  end
end

class ShoppingCart 
  def initialize()
    @items = []
  end
  
  def add(sku, quantity)
    for i in 1..quantity do
      @items += [item]
    end
    puts "Added (#{quantity}) item #{sku} to cart."
  end
  
  def 
end