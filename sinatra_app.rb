require 'sinatra'
set :server, 'trinidad'  # THis line must run before we require 'pacer'
require 'json'
require 'pacer'
require 'app.rb'


# Our graph
@@g = NorthWind.load_graph


def count(route)
	content_type :json
  	route.count.to_json
end

def list_objects(route)
	content_type :json
  	route.properties.to_a.to_json
end



[
	['/customers', NorthWind::Customer], 
	['/suppliers', NorthWind::Supplier],
	['/products', NorthWind::Product], 
	['/orders', NorthWind::Order]
].each do |path, extension|

	get path do
  		list_objects @@g.v(extension)
	end

	get "#{path}/count" do
  		count @@g.v(extension)
	end

end



get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end

