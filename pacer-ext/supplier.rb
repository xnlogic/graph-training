module Northwind
	module Supplier

		def self.route_conditions(graph)
        	{type: "Supplier"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:companyName]} (#{self[:supplierID]})"
        	end

            # Properties

            def name
                self[:companyName]
            end

            def name=(new_name)
                self.properties = self.properties.merge({"companyName" => new_name})
            end

    	end


    	module Route

            def products
                self.out_e(:SUPPLIES).in_v(Northwind::Product)
            end
    		
		end


	end
end