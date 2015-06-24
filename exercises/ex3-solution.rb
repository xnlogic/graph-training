require 'ex1-solution'

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

# Return (a route containing) posts with comments
# from at least 3 different people.
def popular_posts(posts)
  posts.lookahead(min: 3) do |post|
    posted_by(get_comments(post)).uniq
  end
end


# Return (a route containing) people who never got more than one comment
# on any of their posts.
def unpopular_people(people)
  people.neg_lookahead do |person|
    get_posts(person).lookahead(min: 2) do |post|
      get_comments(post)
    end
  end
end
