require_relative 'ex1-solution.rb'
require_relative 'ex3-solution.rb'

# Return (a route containing) all people who commented on any of the given
# person's posts.
# - The `person` argument may be either a vertex or a route.
# - You should ignore people's comments on their own posts.
#
# NOTE: For this exercise, we are only takling about direct comments, no
#       nested comments.
def get_people_who_commented_on_my_posts(person)
  get_fans(person.as(:me)).is_not(:me)
end



# Return (a route containing) other people's comments about posts
# from the given person.
# - The `person` argument may be either a vertex or a route.
#
# NOTE: For this exercise, we are only takling about direct comments, no
#       nested comments.
def get_comments_about_my_posts_from_other_people(person)
  get_comments_on_person_posts(person.as(:me))
    .lookahead  do |comment|
      # Ideal solution:
      # posted_by(comment).is_not(:me)

      # Alternative solution that works around https://github.com/xnlogic/pacer/issues/82
      if person.respond_to? :element
        posted_by(comment).is_not(person)   # If person is a single vertex
      else
        posted_by(comment).except(person)   # If person is a route
      end
    end
end
