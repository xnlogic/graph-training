module Northwind
	module Product

		def self.route_conditions(graph)
        	{type: "Product"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:productName]}, #{self[:unitPrice]}$"
        	end

            def category
               self.categories
            end

    	end


    	module Route
            
            def categories
               self.out_e(:PART_OF).in_v(Northwind::Category)
            end

		end


	end
end