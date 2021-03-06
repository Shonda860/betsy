class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:show, :edit, :update, :destroy]
  
  # Create is adding a product to my cart
  def create
    order = Order.find_by(id: session[:order_id])
    
    if session[:order_id].nil? || order.nil?
      order = Order.create
      session[:order_id] = order.id
    end
    
    order_items = {
    product_id: params[:product_id].to_i,
    quantity: params[:quantity].to_i,
    order_id: session[:order_id],
  }
  
  order = Order.find(session[:order_id])
  # if order item already exists in cart, increase quantity.
  order.order_items.each do |oi|
    if oi.product.id == order_items[:product_id]
      if oi.quantity + order_items[:quantity] > oi.product.stock
        flash[:failure] = "Sorry, there are not enough items in stock."
        redirect_to product_path(order_items[:product_id])
        return
      else
        oi.quantity += order_items[:quantity]
        oi.save
        
        flash[:success] = "Successfully updated quantity."
        redirect_to product_path(order_items[:product_id])
        return
      end
    end
  end
  
  order_item = OrderItem.new(order_items)
  if order_item.save
    flash[:success] = "Successfully added item to your cart."
    redirect_to product_path(order_items[:product_id])
    return
  else
    flash[:failure] = "Item could not be added to your cart."
    redirect_to product_path(order_items[:product_id])
    return
  end
end

#Delete is going to be "remove products from my cart."
def destroy
  @order_item.destroy
  redirect_to order_path(@order_item.order_id)
end

#Update is going to change the quantity of my cart."
def update
  order_items_params = {
  product_id: @order_item.product_id,
  order_id: @order_item.order_id,
  quantity: params[:quantity]
}  

if @order_item.update(order_items_params)
  redirect_to order_path(@order_item.order_id)
  return
end
end

def complete
  user_id = logged_in?
  if user_id
    oi_id = params[:id]
    oi = OrderItem.find_by(id: oi_id)
    
    oi.status = "complete"
    oi.save
    
    redirect_to dashboard_path(user_id)
    return
  end
end

private

def order_items_params
  params.require(:order_item).permit(:quantity, :product_id, :order_id)
end

def find_order_item
  @order_item = OrderItem.find_by(id: params[:id])
end

def find_order_item
  @order_item = OrderItem.find_by(id: params[:id])
end

end
