require 'pacer'



# Return a vertex
def create_person(graph, name)
  graph.create_vertex('type' => 'person', 'name' => name)
end

# Return a vertex
def create_post(graph, person, text)
  post = graph.create_vertex('type' => 'post', 'text' => text, 'timestamp' => Time.now)
  person.add_edges_to :POSTED, post
  post
end

# Return a vertex-route
# - person is a vertex or a vertex-route.
def get_posts(person)
  person.out_e(:POSTED).in_v(type: 'post')
end




# Return a vertex
def create_comment(graph, person, post_or_comment, text)
  comment = graph.create_vertex('type' => 'comment', 'text' => text, 'timestamp' => Time.now)
  person.add_edges_to :POSTED, comment
  comment.add_edges_to :IS_ABOUT, post_or_comment
  comment
end

# Return a vertex-route
# - post_or_comment is either a vertex or a vertex-route.
def get_comments(post_or_comment)
  post_or_comment.in_e(:IS_ABOUT).out_v(type: 'comment')
end




# Return a vertex-route
# - post_or_comment is either a vertex or a vertex-route.
def get_comments_on_person_posts(person)
  get_comments get_posts(person)
end

# Return a vertex-route.
# A fan is any person who commented on any of the given person's posts.
# - person is either a vertex or a vertex-route.
#
# Q: What are the pros/cons of uniq'ing the result?
#
def get_fans(person)
  get_comments_on_person_posts(person).in_e(:POSTED).out_v(type: 'person')
end

# Return a vertex-route.
# Return posts that were posted by the given person's fans
# - person is either a vertex or a vertex-route.
def get_fans_posts(person)
  get_posts(get_fans(person))
end

# Return a vertex-route.
# - person is either a vertex or a vertex-route.
def get_fans_of_fans(person)
  get_fans get_fans(person)
end




# Return all comments (and comments on comments, and comments on comments on
# comments, and so on ...) about the given post.
#
# Return an array of vertices
#
# - post is either a vertex or a vertex-route.
def get_all_comments(post)
    result = []

    # We will get all comments (and their comments, and their comments,
    # and so on ...) using a simplified version of breadth-first-search.
    #
    # NOTE: This is an inefficient way to perform loops in Pacer!
    #  At each iteration of the while-loop below, we evaluate a route.
    #  Evaluating a route (i.e. streaming items from the underlying graph
    #  to your application) can be an expensive operation.
    #  Pacer routes have a `loop` method that allows you to loop (i.e. repeat
    #  traversals) without repeatedly evaluating routes.

    q = [ post ]
    while not q.empty?
      # Remove an item from the front of the queue
      post_or_comment = q.shift
      # Get the item's comments
      get_comments(post_or_comment).each do |comment|
        # Store each comment in the result, and also add it to the queue
        result.push comment
        q.push comment
      end
    end

    result
end
