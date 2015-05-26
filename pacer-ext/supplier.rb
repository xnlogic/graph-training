module Northwind
	module Supplier

		def self.route_conditions(graph)
        	{type: "Supplier"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:companyName]} (#{self[:supplierID]})"
        	end

    	end


    	module Route

            def products
                self.out_e(:SUPPLIES).in_v(Northwind::Product)
            end
    		
		end


	end
end