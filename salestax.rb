# Copyright (c) 2012 Jason McVetta.  This is Free Software, released under the
# terms of the AGPL v3.  See www.gnu.org/licenses/agpl-3.0.html for details.
#
#-------------------------------------------------------------------------------
#
# USAGE:
# 
#     ruby salestax.rb /path/to/datafile
#
# or to see an example:
#
#     ruby salestax.rb --example
#
# Data file format is one sku per line - quantities greater than 1 are expressed by the 
# same skew repeated on multiple lines.
#
#-------------------------------------------------------------------------------

SALES_TAX_RATE = 0.10  # 10% tax on most sales
IMPORT_TAX_RATE = 0.05 # 5% tax on all imports

# Realistically the product catalog, as well as the list of tax exempt categories 
# below, would be stored in a database.
PRODUCT_CATALOG = {
  # sku => properties
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

# Categories in this list are exempt from sales (but not import) tax.
TAX_EXEMPT = [
  "book",
  "medical",
  "food",
]



require "optparse"

# An item of merchandise that can be added to the Shopping Cart
class MerchandiseItem

  include Comparable
  
  attr_reader :sku
  attr_reader :name
  attr_reader :category
  attr_reader :price
  attr_reader :imported
  
  def initialize(sku)
    sku = sku.to_s
    if not PRODUCT_CATALOG.has_key?(sku)
      raise "Sku #{sku} not found in catalog"
    end
    item = PRODUCT_CATALOG[sku]
    @sku = sku
    @name = item["name"]
    @category = item["category"]
    @price = item["price"]
    @imported = item["imported"]
  end
  
  def <=>(other)
    @sku <=> other.sku
  end
  
  def eql?(other)
    @sku <=> other.sku
  end
  
  def hash
    @sku.hash
  end
  
  def tax
    tax = 0
    # Import Duty
    if @imported
      tax += @price * 0.05
    end
    # Sales Tax
    if not TAX_EXEMPT.include?(@category)
      tax += @price * SALES_TAX_RATE
    end
    #
    # Round up to the nearext $0.05
    #
    tax = (tax*20.0).ceil / 20.0 # (1/0.05 = 20)
    return tax
  end
  
  def total
    @price + tax
  end
  
  def to_s
    "(%-10s) %-54s: %7.2f" % [@category, @name, @price]
  end
end

# A very simple shopping cart class ShoppingCart 
class ShoppingCart
  def initialize()
    @items = Hash.new(0)
  end
  
  def add(sku, quantity)
    # In a production system, MerchandiseItem might be an ActiveRecord class 
    # or similar.  We would query the DB here and get a valid instance or a 
    # does not exist error.  
    item = MerchandiseItem.new(sku)
    @items[item] += 1
  end
  
  # Sum of pre-tax prices on all items
  def subtotal
    sum = 0
    @items.each_pair { |item, quantity|
      sum += item.price * quantity   
    }
    return sum
  end
  
  # Sum of tax on all items
  def tax
    sum = 0
    @items.each_pair { |item, quantity|
      sum += item.tax * quantity   
    }
    return sum
  end
  
  def total
    total = subtotal + tax
    return total
  end
  
  # Prints receipt
  def receipt
    @items.each_pair { |item, quantity|
      #puts "#{quantity} #{item}"
      puts "%3s %s" % [quantity, item]
    }
  #puts "Sales Taxes: #{tax}"
  puts "-" * 80
  puts "Sales Taxes:                                                             %7.2f" % tax
  puts "Total:                                                                   %7.2f" % total
  end
end


def example
  puts "+" * 80
  puts
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


def main
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: salestax.rb [options] [file]"
  
    opts.on("-e", "--example", "Run example") do |v|
      #options[:verbose] = v
      example
      exit
    end
  end.parse!
  # If an argument is specified, is assumed to be the path to a data file.  File 
  # contains one sku per line - quantities greater than 1 are expressed by the 
  # same skew repeated on multiple lines.
  if ARGV.size > 0
    cart = ShoppingCart.new
    file = File.new(ARGV[0], "r")
    while (line = file.gets)
      sku = line.strip
      cart.add(sku, 1)
    end
    file.close
    cart.receipt
  else
    puts "Must specify either a data file or --example."
  end
end  

if __FILE__ == $PROGRAM_NAME
  main
end
