require 'pacer'


def create_simple_data(graph)
  alice = graph.create_vertex({type: 'person', name: 'Alice'})
  bob   = graph.create_vertex({type: 'person', name: 'Bob'})
  post  = graph.create_vertex({type: 'post', text: 'Learning about Pacer ...'})

  alice.add_edges_to( :follows, bob,  {since: Time.now})
  bob.add_edges_to(   :posted,  post, {timestamp: Time.now})
  alice.add_edges_to( :likes,   post, {timestamp: Time.now})

end
