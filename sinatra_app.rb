require 'sinatra'
set :server, 'trinidad'  # This line must run before we require 'pacer'
require 'json'
require 'pacer'
require 'app.rb'


# Our graph
@@g = NorthWind.load_graph

# Serve the front-end application
get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end

# =============================================================================

@@ext2id_property = {
	NorthWind::Customer => :customerID,
	NorthWind::Supplier => :supplierID,
	NorthWind::Product  => :productID,
	NorthWind::Order    => :orderID,
	NorthWind::Employee => :employeeID,
	NorthWind::Category => :categoryID	
}

@@ext2path_prefix = {
	NorthWind::Customer => '/customers',
	NorthWind::Supplier => '/suppliers',
	NorthWind::Product  => '/products',
	NorthWind::Order    => '/orders',
	NorthWind::Employee => '/employees',
	NorthWind::Category => '/categories'	
}

# =============================================================================
# Helper functions

def respond_with_json(obj)
	content_type :json
	if obj
		obj.to_json
	else
		status 404
  		body '"Item not found"'
  	end
end

def count(route)
	respond_with_json route.count
end

def list_objects(route)
 	respond_with_json route.properties.to_a
end

def list_object(element)
	respond_with_json (element.nil? ? nil : element.properties)
end


# extension - The extension of the start/source vertex
# relation|element| - A block that returns a route of the related elements.
def one_to_many(extension, &relation)
	id_property_key = @@ext2id_property[extension]
	id_property_value = params[:item_id]

	item = @@g.v(extension, { id_property_key => id_property_value}).first
	if(item)
		list_objects relation.call(item) 
	end
end

# =============================================================================
# API

# For each extension ...
@@ext2id_property.each do |ext, id_property|

	path_prefix = @@ext2path_prefix[ext]

	# API call to list all elements of the given extension
	get path_prefix do
  		list_objects @@g.v(ext)
	end

	# API call to count all elements of the given extension
	get "#{path_prefix}/count" do
  		count @@g.v(ext)
	end

	# API call to get a specific item
	get "#{path_prefix}/:item_id" do
  		list_object @@g.v(ext, { id_property => params[:item_id] }).first
	end

end


# One-to-Many relations ... 
{
	NorthWind::Customer => {
		:suggest_products => Proc.new {|customer| customer.suggest_products},
		:orders	 => Proc.new {|customer| customer.orders},	
		:favorite_sales_staff => Proc.new {|customer| customer.orders.employees.most_frequent(0..2)},
		:favorite_products => Proc.new {|customer| customer.orders.products.most_frequent(0..5)}
	},

	NorthWind::Category => {
		:products => Proc.new {|category| category.products},
		:suppliers => Proc.new {|category| category.products.suppliers.uniq}
	},

	NorthWind::Order => {

	},

	NorthWind::Product => {
		:suppliers => Proc.new {|product| product.suppliers}
	},

	NorthWind::Employee => {
		:customers => Proc.new {|employee| employee.orders.customers.uniq}
	},

	NorthWind::Supplier => {
		:products => Proc.new {|supplier| supplier.products} 

	}
}
.each do |ext, relations|
	relations.each do |rel, route|

		get "#{@@ext2path_prefix[ext]}/:item_id/#{rel}" do
			one_to_many(ext, &route)
		end	

	end
end
