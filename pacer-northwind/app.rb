module NorthWind

	require 'pacer'

	def self.load_extensions
		Dir["pacer-ext/*.rb"].each {|extension| load extension}
	end


	def self.populate_graph(g)
		Pacer::GraphML.import(g, 'northwind.graphml')
		g
	end

	# TIP: Given a graph g, you can get a full report of its structure (vertices and edges) using
	# Pacer::Utils::GraphAnalysis.structure g

	load_extensions()

end

