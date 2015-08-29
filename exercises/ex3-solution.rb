require_relative 'ex1-solution.rb'

# Helper function.
# Return the person who posted the given post.
# The `comment_or_post` argument might be a route. Therefore, the returned
# value is a route as well.
def posted_by(comment_or_post)
  comment_or_post.in_e(:POSTED).out_v(type: 'person')
end

# Return (a route containing) people who posted at least one post
def posted_something(people)
  people.lookahead do |person|
    get_posts(person)
  end
end

# Return (a route containing) posts with comments from at least 2 different
# people.
#
# NOTE: For this exercise, we are only takling about direct comments, no
#       nested comments.
def popular_posts(posts)
  posts.lookahead(min: 2) do |post|
    post.in_e(:IS_ABOUT).out_v(type: 'comment').in_e(:POSTED).out_v(type: 'person').uniq
  end
end


# Return (a route containing) people who never got more than one comment
# on any of their posts.
#
# NOTE: For this exercise, we are only takling about direct comments, no
#       nested comments.
def unpopular_people(people)
  people.neg_lookahead do |person|
    get_posts(person).lookahead(min: 2) do |post|
      get_comments(post)
    end
  end
end
