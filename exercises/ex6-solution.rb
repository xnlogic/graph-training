require 'ex1-solution'

# Get the number of posts posted by each person from the given people.
# - The `people` argument is a route.
# - Return a route of arrays, each array containing two items:
#     1. A person (vertex)
#     2. A count (integer)
def count_posts(people)
  get_posts(people.as(:person)).count_section(:person)
end

# Get comments about the given posts.
#   `posts` is a route
#   `max_comments_per_post` is an integer indicating the max' number of comments
#   we should get for each post.
def sample_comments(posts, max_comments_per_post)
  get_comments(posts.as(:post)).limit_section(:post, max_comments_per_post)
end
