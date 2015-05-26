module Northwind
	module Order

		def self.route_conditions(graph)
        	{type: "Order"}
    	end
		

		module Vertex

    	    def display_name
        	    "Order #{self[:orderID]}"
        	end

            def employee
                self.employees.first
            end

            def customer
                self.customers.first
            end

    	end


    	module Route

            def employees
                self.in_e(:SOLD).out_v(Northwind::Employee)
            end

            def customers
                self.in_e(:PURCHASED).out_v(Northwind::Customer)
            end

		end


	end
end