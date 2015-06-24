
def get_person_by_name(graph, name)
  graph.v(type: 'person', name: 'Alice')
end


def get_posts_and_comments_by(person)
  person.out_e(:POSTED).in_v(type: Set['post','comment'])
end

# Get posts from the last 24 hours
def get_recent_posts_and_comments(graph)
  graph.v.where('(type = "post" or type = "comment") and timestamp >:t',
            t: (Time.now - 60 * 60 * 24))
end


# Get people who posted at 3 posts and/or comments
# during the last week.
def active_people(graph)
  graph.v(type: 'person').filter do |person|
    get_posts_and_comments_by(person)
      .where('timestamp > :t', t: (Time.now - 60 * 60 * 24 * 7))
        .count > 3
  end
end


# Get a person who posted the highest number of posts and/or comments
# during the last 24 hours
def most_active_person(graph)
  get_recent_posts_and_comments(graph)
    .in_e(:POSTED).out_v(type: 'person')
      .most_frequent
end
