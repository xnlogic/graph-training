module Northwind

	require 'pacer'
	require 'pacer-ext/customer'
	require 'pacer-ext/order'
	require 'pacer-ext/employee'



	def self.load_graph
		g = Pacer.tg
		Pacer::GraphML.import(g, 'northwind.graphml')
		g
	end

end

