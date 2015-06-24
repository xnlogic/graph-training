require 'ex1-solution'

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
    get_comments(post).in_e(:POSTED).out_v(type: 'person').uniq
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
