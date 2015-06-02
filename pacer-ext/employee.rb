module NorthWind
	module Employee

		def self.route_conditions(graph)
        	{type: "Employee"}
    	end
		

		module Vertex

    	    def display_name
        	    "#{self[:firstName]} #{self[:lastName]}, #{self[:title]}"
        	end

            # Properties

            def name
                "#{self[:firstName]} #{self[:lastName]}"
            end
            

            def title
                self[:title]
            end

            def title=(new_title)
                self.properties = self.properties.merge({"title" => new_title})
            end

            # Relations

            def reports_to
                self.out_e(:REPORTS_TO).in_v(NorthWind::Employee)
            end


    	end


    	module Route

    		def orders
    			self.out_e(:SOLD).in_v(NorthWind::Order)
    		end

            def report_to
                self.out_e(:REPORTS_TO).in_v(NorthWind::Employee)
            end

		end


	end
end