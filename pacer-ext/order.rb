module NorthWind
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

            def total_price
                t = 0.0
                self.out_e(:PRODUCT).properties.each {|p| t += p['unitPrice'] * p['quantity']}
                return t
            end

            # Properties

            def shipped_by
                "#{self[:shipName]}"
            end

    	end


    	module Route

            def employees
                self.in_e(:SOLD).out_v(NorthWind::Employee)
            end

            def customers
                self.in_e(:PURCHASED).out_v(NorthWind::Customer)
            end

            def products
                # Edge properties are 'unitPrice' and 'quantity' (both have double values)
                self.out_e(:PRODUCT).in_v(NorthWind::Product)
            end


            def shipped_by
                self.properties['shipName']
            end

		end


	end
end