module NorthWind

	require 'pacer'


	def self.load_extensions
		Dir["pacer-ext/*.rb"].each {|extension| load extension}
	end


	def self.load_graph
		g = Pacer.tg
		Pacer::GraphML.import(g, 'northwind.graphml')
		g
	end

	def self.schema_info(g, type)
		r = nil
		if type.nil?
			r = g.v
		else
			r = g.v(type: type)
		end

		{v: _vertex_info(r), e: _edge_info(r)}
	end

	# Go over the vertices in the given vertex_route, and return
	# a hash where:
	# - The keys are all the different `type`s.
	# - The Values are all property names of vertices with that type.
	def self._vertex_info(vertex_route)
		info = Hash.new { Set.new }
		vertex_route.each  do |v| 
			info[v[:type]] =  info[v[:type]].add(v.properties.keys)
		end
		info
	end

	def self._edge_info(vertex_route)
		info = Set.new
		vertex_route.both_e.each{ |e| info.add([e.out_v.first[:type], e.label, e.in_v.first[:type]]) }
		info
	end



	load_extensions()

end

