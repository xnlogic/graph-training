require 'ex1-solution'
require 'ex3-solution'

# Return (a route containing) all people who commented on any of the given
# person's posts.
# - The `person` argument may be either a vertex or a route.
# - You should ignore people's comments on their own posts.
def get_people_who_commented_on_my_posts(person)
  get_fans(person.as(:me)).is_not(:me)
end



# Return (a route containing) other people's comments about posts
# from the given person.
# - The `person` argument may be either a vertex or a route.
def get_comments_about_my_posts_from_other_people(person)
  get_comments_on_person_posts(person.as(:me))
    .lookahead  do |comment|
      posted_by(comment).is_not(:me)
    end
end
