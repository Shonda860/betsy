class Order < ApplicationRecord
  has_many :order_items
  
  validates :address, :name, :cc_num, :cvv_code, :exp_date, :zip, presence: true, on: :update
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :update
  validates :exp_date, presence: true, format: { with: /\A(\d{2})\/(\d{2})\Z/ }, on: :update 
  
  def total
    total = 0
    self.order_items.each do |oi|
      total += oi.subtotal
    end
    
    return total
  end
  
  def update_stock
    self.order_items.each do |oi|
      oi.product.stock -= oi.quantity
      oi.product.save
    end
    
  end
  
  def count_items
    items = self.order_items
    count = nil
    
    count = items.count
    
    return count
  end
end 
