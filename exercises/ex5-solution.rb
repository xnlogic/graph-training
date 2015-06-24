

def get_posts_liked_or_posted_by(person)
  person
    .branch do |p|
      p.out_e(:LIKES).in_v(type: 'post')
    end
    .branch do |p|
      p.out_e(:POSTED).in_v(type: 'post')
    end
    .merge
end



# Get followers of the given person, and their followers, and their followers,
# and so on. Up until 6 degrees of separation.
def get_social_reach(person)
  person

  .loop do |p|
    p.in_e(:FOLLOWS).out_v(type: 'person').uniq
  end

  .while do |p, depth|
    if depth == 0
       :loop
    else depth <= 6
       :loop_and_emit
    else
       false
    end
  end

end
