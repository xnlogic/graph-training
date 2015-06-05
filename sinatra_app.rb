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
	['/orders', NorthWind::Order, :orderID]
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






# Serve the front-end application

get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end

