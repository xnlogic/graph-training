module NorthWind
	module Category

		def self.route_conditions(graph)
        	{type: "Category"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:categoryName]} - #{self[:description]}"
        	end    

    	end


    	module Route
    		
            def products
                self.in_e(:PART_OF).out_v(NorthWind::Product)
            end

		end


	end
end