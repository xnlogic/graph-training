module Northwind
	module Employee

		def self.route_conditions(graph)
        	{type: "Employee"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:firstName]} #{self[:lastName]}, #{self[:title]}"
        	end

    	end


    	module Route

    		def orders
    			self.out_e(:SOLD).in_v(Northwind::Order)
    		end

		end


	end
end