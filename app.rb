module Northwind

	require 'pacer'
	require 'pacer-ext/customer'



	def self.load_graph
		g = Pacer.tg
		Pacer::GraphML.import(g, 'northwind.graphml')
		g
	end

end

