# Copyright (c) 2012 Jason McVetta.  This is Free Software, released under the
# terms of the AGPL v3.  See www.gnu.org/licenses/agpl-3.0.html for details.


require "salestax"
require "test/unit"

# Test cases based on the original problem specification
class TestSalesTax  < Test::Unit::TestCase

  def test_1
    # Input 1:
    # 1 book at 12.49
    # 1 music CD at 14.99
    # 1 chocolate bar at 0.85
    #
    # Output 1:
    # 1 book : 12.49
    # 1 music CD: 16.49
    # 1 chocolate bar: 0.85
    # Sales Taxes: 1.50
    # Total: 29.83

    cart = ShoppingCart.new
    cart.add("10001", 1)
    cart.add("10002", 1)
    cart.add("10003", 1)
    assert_equal cart.tax, 1.50
    assert_equal cart.total, 29.83
  end
  
  def test_2
    # Input 2:
    # 1 imported box of chocolates at 10.00
    # 1 imported bottle of perfume at 47.50
    #
    # Output 2:
    # 1 imported box of chocolates: 10.50
    # 1 imported bottle of perfume: 54.65
    # Sales Taxes: 7.65
    # Total: 65.15
    cart = ShoppingCart.new
    cart.add("10004", 1)
    cart.add("10005", 1)
    assert_equal cart.tax, 7.65
    assert_equal cart.total, 65.15
  end
  
  def test_3
    # Input 3:
    # 1 imported bottle of perfume at 27.99
    # 1 bottle of perfume at 18.99
    # 1 packet of headache pills at 9.75
    # 1 box of imported chocolates at 11.25
    #
    # Output 3:
    # 1 imported bottle of perfume: 32.19
    # 1 bottle of perfume: 20.89
    # 1 packet of headache pills: 9.75
    # 1 imported box of chocolates: 11.85
    # Sales Taxes: 6.70
    # Total: 74.68
    cart = ShoppingCart.new
    cart.add("10006", 1)
    cart.add("10007", 1)
    cart.add("10008", 1)
    cart.add("10009", 1)
    assert_equal cart.tax, 6.70
    assert_equal cart.total, 74.68
  end
  
end
