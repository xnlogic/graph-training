module Northwind

	require 'pacer'


	def self.load_extensions
		Dir["pacer-ext/*.rb"].each {|extension| load extension}
	end


	def self.load_graph
		g = Pacer.tg
		Pacer::GraphML.import(g, 'northwind.graphml')
		g
	end

	load_extensions()

end

