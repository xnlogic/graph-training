require 'sinatra'
set :server, 'trinidad'  # This line must run before we require 'pacer'
require 'json'
require 'pacer'
require 'app.rb'


# =============================================================================
# Initialization ...

@@g = nil 

if(ARGV.length == 0)
	puts "\n=================================================================================\n\n"
	puts "INFO: No database file supplied, using in-memory TinkerGraph."
	puts "If you would like to use Neo4j, you should provide the path to the database file."
	puts "For example: ruby run_demo.rb /home/xnlogic/data/northwind-data"
	puts "\n=================================================================================\n\n"
	@@g = Pacer.tg
else
	puts "\n=================================================================================\n\n"
	puts "INFO: Using Neo4j."
	puts "Graph data will be stored at '#{ARGV[0]}'"
	puts "\n=================================================================================\n\n"
	require 'pacer-neo4j'
	@@g = Pacer.neo4j ARGV[0]
end

# Load the graph data
Pacer::GraphML.import(@@g, 'northwind.graphml')
# Load the Pacer extension modules
Dir["pacer-ext/*.rb"].each {|extension| load extension}


# =============================================================================
# Map URL's to actions

# Home page
get '/' do
	send_file File.join(settings.public_folder, 'index.html')
end


# A simple API call - Return the number customers in the graph
get '/customers/count' do
	content_type :json
	count = @@g.v(NorthWind::Customer).count
	"#{count}"  # The response
end

# Another API call - Get the customer with a specified :customer_id
# The response will be a JSON object containing all properties of the customer vertex.
get '/customers/:customer_id' do
	content_type :json
	customer = @@g.v(NorthWind::Customer, customerID: params[:customer_id]).first

	if customer
		customer.properties.to_json
	else
		status 404
  		body '"Item not found"'
	end
end


# =============================================================================
# Let's define more API calls ...


# Helper objects and functions
# ----------------------------

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
	# If the element is an Order, we want to collect all OrderItems
	if( element.extensions.include? NorthWind::Order)
		response = element.properties

		# Collect all order items ...
		orderItems = []
		element.order_items.each do |item| 
			orderItems << {price: item.price, quantity: item.quantity, product_name: item.product.name}
		end
		response[:order_items] = orderItems

		respond_with_json response
	else
		respond_with_json (element.nil? ? nil : element.properties)
	end
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


# Basic API calls
# ---------------

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


# One-to-Many relations
# ---------------------

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
		:suppliers => Proc.new {|product| product.suppliers},
		:customers => Proc.new {|product| product.orders.customers.uniq}
	},

	NorthWind::Employee => {
		:customers => Proc.new {|employee| employee.orders.customers.uniq},
		:products => Proc.new {|employee| employee.orders.products.uniq}
	},

	NorthWind::Supplier => {
		:products => Proc.new {|supplier| supplier.products},
		:categories => Proc.new {|supplier| supplier.products.categories.uniq } 
	}
}
.each do |ext, relations|
	relations.each do |rel, route|

		get "#{@@ext2path_prefix[ext]}/:item_id/#{rel}" do
			one_to_many(ext, &route)
		end	

	end
end
