module NorthWind
	module OrderItem

		def self.route_conditions(graph)
        	:PRODUCT
    	end

		module Edge

			def display_name
        	    "#{self.quantity} units of #{self.product.name} at $#{self.price}/unit"
        	end

        	def order
        		self.out_vertex(NorthWind::Order)
        	end

        	def product
        		self.in_vertex(NorthWind::Product)
        	end

        	def quantity
        		self[:quantity]
        	end

					def price
        		self[:unitPrice]
        	end

		end

		module Route
			def orders
        		self.out_v(NorthWind::Order)
        	end

        	def products
        		self.in_v(NorthWind::Product)
        	end
		end
	end
end
