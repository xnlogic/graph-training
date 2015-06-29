require 'sinatra'
set :server, 'trinidad'  # This line must run before we require 'pacer'
require 'json'
require 'pacer'



#==============================================================================
# Initialization ...

@@g = Pacer.tg   # Global graph object
Pacer::GraphML.import(@@g, 'pacer-northwind/northwind.graphml')
# Load the Pacer extension modules
Dir['pacer-northwind/pacer-ext/*.rb'].each {|extension| load extension}



#==============================================================================
# Define API calls


get '/customers/:customer_id' do
	content_type :json
	id = params[:customer_id]
	customer = @@g.v(NorthWind::Customer, customerID: id).first

	if customer
		customer.properties.to_json
	else
		status 404
	end
end


get '/customers/:customer_id/purchases' do
	content_type :json
	id = params[:customer_id]
	products = @@g.v(NorthWind::Customer, customerID: id).products.uniq

	if products
		products.properties.to_a.to_json
	else
		status 404
	end
end

