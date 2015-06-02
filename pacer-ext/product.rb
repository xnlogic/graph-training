module NorthWind
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

          def name
            self[:productName]
          end
            
            def categories
               self.out_e(:PART_OF).in_v(NorthWind::Category)
            end

            def orders
               self.in_e(:PRODUCT).out_v(NorthWind::Order)
            end

            def suppliers
               self.in_e(:SUPPLIES).out_v(NorthWind::Supplier)
            end

		end


	end
end