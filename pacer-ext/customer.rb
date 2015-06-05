module NorthWind
	module Customer

		def self.route_conditions(graph)
        	{type: "Customer"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:companyName]} (#{self[:customerID]})"
        	end

            def suggest_products
                self.as(:me).products.customers.is_not(:me)
                .products.except(self.products).most_frequent(0..2)
            end

    	end


    	module Route

    		def orders
    			self.out_e(:PURCHASED).in_v(NorthWind::Order)
    		end

            def products
                self.orders.products
            end

            def name
                self[:companyName]
            end
    		
		end


	end
end