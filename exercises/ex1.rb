require 'pacer'



# Return a vertex
def create_person(graph, name)

end

# Return a vertex
def create_post(graph, person, text)

end

# Return a vertex-route
# - person is a vertex or a vertex-route.
def get_posts(person)

end



# Return a vertex
def create_comment(graph, person, post_or_comment, text)

end

# Return a vertex-route
# - post_or_comment is either a vertex or a vertex-route.
def get_comments(post_or_comment)

end



# Return a vertex-route
# - post_or_comment is either a vertex or a vertex-route.
def get_comments_on_person_posts(person)

end

# Return a vertex-route.
# A fan is any person who commented on any of the given person's posts.
# - person is either a vertex or a vertex-route.
#
# Q: What are the pros/cons of uniq'ing the result?
#
def get_fans(person)

end

# Return a vertex-route.
# Return posts that were posted by the given person's fans
# - person is either a vertex or a vertex-route.
def get_fans_posts(person)

end

# Return a vertex-route.
# - person is either a vertex or a vertex-route.
def get_fans_of_fans(person)

end



# Return all comments (and comments on comments, and comments on comments on
# comments, and so on ...) about the given post.
#
# Return an array of vertices
#
# - post is either a vertex or a vertex-route.
def get_all_comments(post)

end
