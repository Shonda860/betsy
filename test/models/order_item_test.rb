require "test_helper"

describe OrderItem do
  describe 'relations' do
    before do
      @product = products(:begonia)
      @order = orders(:myrta_order)
      @order_item = OrderItem.new(quantity: 1, product_id: @product.id, order_id: @order.id)
    end
    
    it 'an order_item belongs to a product' do
      expect(@order_item.product_id).must_equal @product.id
    end
    
    it 'an order_item belongs to an order' do
      expect(@order_item.order_id).must_equal @order.id
    end
  end
  
  describe 'validations' do
    let(:product) { products(:begonia) }
    let(:order) { orders(:myrta_order) }
    let(:order_item) { OrderItem.new(quantity: 1, product_id: product.id, order_id: order.id) }
    
    it 'is valid when a quantity of 1 or more is entered' do
      # Default quantity is 1
      expect(order_item.valid?).must_equal true
      
      order_item.quantity = 2
      expect(order_item.valid?).must_equal true
    end
    
    it 'is not valid when a quantity of less than 1 is entered' do
      order_item.quantity = 0
      expect(order_item.valid?).must_equal false
      
      order_item.quantity = -1
      expect(order_item.valid?).must_equal false
    end
    
    it 'is not valid with a quantity that is not an integer' do
      order_item.quantity = "three"
      expect(order_item.valid?).must_equal false
    end
  end
  
  describe 'subtotal' do
    let(:order_item) { order_items(:bear_hollyhock) }
    
    it 'calcualtes the correct subtotal' do
      expect(order_item.subtotal).must_equal 25.5
    end
  end
end
