require 'sinatra'
set :server, 'trinidad'  # THis line must run before we require 'pacer'
require 'json'
require 'pacer'
require 'app.rb'


# Our graph
@@g = NorthWind.load_graph



# Helper functions

def count(route)
	content_type :json
  	route.count.to_json
end

def list_objects(route)
	content_type :json
  	route.properties.to_a.to_json
end

def list_object(element)
	content_type :json
	if element 
  		element.properties.to_json
  	else
  		status 404
  		body '"Item not found"'
  	end
end


# Create basic URLs to count, list and get objects...

[
	['/customers', NorthWind::Customer, :customerID], 
	['/suppliers', NorthWind::Supplier, :supplierID],
	['/products', NorthWind::Product, :productID], 
	['/orders', NorthWind::Order, :orderID],
	['/employees', NorthWind::Employee, :employeeID],
	['/categories', NorthWind::Category, :categoryID]
].each do |path, extension, id_property|

	get path do
  		list_objects @@g.v(extension)
	end

	get "#{path}/count" do
  		count @@g.v(extension)
	end

	get "#{path}/:item_id" do
  		list_object @@g.v(extension, { id_property => params[:item_id] }).first
	end

end


# Specific URLs
get '/customers/:item_id/suggest_products' do
	customer = @@g.v(NorthWind::Customer, customerID: params[:item_id]).first
	if(customer)
		list_objects customer.suggest_products
	else
	end
end

get '/customers/:item_id/orders' do
	customer = @@g.v(NorthWind::Customer, customerID: params[:item_id]).first
	if(customer)
		list_objects customer.orders
	else
	end
end

get '/customers/:item_id/favorite_sales_staff' do
	customer = @@g.v(NorthWind::Customer, customerID: params[:item_id]).first
	if(customer)
		list_objects customer.orders.employees.most_frequent(0..2)
	else
	end
end

get '/customers/:item_id/favorite_products' do
	customer = @@g.v(NorthWind::Customer, customerID: params[:item_id]).first
	if(customer)
		list_objects customer.orders.products.most_frequent(0..5)
	else
	end
end



get '/categories/:item_id/products' do
	category = @@g.v(NorthWind::Category, categoryID: params[:item_id]).first
	if(category)
		list_objects category.products
	else
	end
end

get '/categories/:item_id/suppliers' do
	category = @@g.v(NorthWind::Category, categoryID: params[:item_id]).first
	if(category)
		list_objects category.products.suppliers.uniq
	else
	end
end

get '/suppliers/:item_id/products' do
	supplier = @@g.v(NorthWind::Supplier, supplierID: params[:item_id]).first
	if(supplier)
		list_objects supplier.products
	else
	end
end

get '/employees/:item_id/customers' do
	employee = @@g.v(NorthWind::Employee, employeeID: params[:item_id]).first
	if(employee)
		list_objects employee.orders.customers.uniq
	else
	end
end



# Serve the front-end application

get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end

