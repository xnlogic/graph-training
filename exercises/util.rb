gem "minitest"
require 'minitest/autorun'
require 'pacer'


#===============================================================================

@@test_data = {
  :Alice => [
    {
      text: 'Foo',
      comments: [
        {by: :Bob, text: 'Bar'}
      ]
    },

    {
      text: "Learning about graph db's",
      comments: [
        {by: :Charlie, text: 'Sounds interesting'}
      ]
    }
  ], # END Alice's posts


  :Bob => [
    {text: "Bob's only post!", comments: [
      {by: :Dave, text: "And Dave's only comment"}
      ] }
  ] , # END Bob's posts


  :Charlie => [

  ] , # END Charlie's posts

  :Dave => [
    {
      text: "Dave's interesting post",
      comments: [
        {
          by: :Bob, text: 'Comment 1',
          comments: [
            {by: :Dave, text: 'Comment 1.1'},
            {by: :Alice, text: 'Comment 1.2'}
          ]
        },
        {
          by: :Alice, text: 'Comment 2',
          comments: [
            {
              by: :Dave, text: 'Comment 2.1',
              comments: [
                {by: :Charlie, text: 'Comment 2.1.1'},
                {by: :Alice, text: 'Comment 2.1.2'}
              ]
            }
          ]
        }
      ]
    },
  ]# END Dave's posts
}


#===============================================================================


class BaseTestSuite < Minitest::Test

  # The setup method runs before *every* test case and does the following:
  # 1. Creates a new graph
  # 2. Populates it with vertices and edges, based on the data defined
  #    at the top of this file.
  # 3. Stores the created vertices in instance variables.
  #    (we use these instance variables in our test_XXX methods below)
  def setup
    @g = Pacer.tg

    @people = Hash.new(nil)  # Name (string) to Person (vertex)
    @posts = Hash.new {|hsh, key| hsh[key] = [] }   # Person's name (string) to the person's posts (array of vertices)
    @comments = Hash.new {|hsh, key| hsh[key] = [] } # Post/Comment (vertex) to comments about that post/comment (array of vertices)


    @@test_data.each do |name, _|
      @people[name] = create_person @g, name
    end

    @@test_data.each do |name, posts_data|
      posts_data.each  do |post_data|
            # Create the post
            post = create_post(@g, @people[name], post_data[:text])
            # Store it in an instance variable
            @posts[name] << post
            # Process its comments
            if(post_data[:comments])
              post_data[:comments].each {|c| _create_comment_about(post, c)}
            end

        end
    end

  end


  #=============================================================================
  # Helper Methods
  #=============================================================================


  # Create a comments recursively.
  # - comment_or_post is the vertex we're commenting about
  # - data is a hash with keys `text` and `comments`.
  #        `text` is the text of the comment we're creating.
  #        `comments` contains the data for comments on the comment we just created.
  def _create_comment_about(comment_or_post, data)
    person = @people[data[:by]]
    new_comment = create_comment @g, person,  comment_or_post, data[:text]
    @comments[comment_or_post] << new_comment

    # Create comments recursively ...
    if(data[:comments])
      data[:comments].each {|c| _create_comment_about(new_comment, c)}
    end
  end


  def _assert_is_vertex_or_vertex_route(created_obj, create_method_name)
    refute_nil created_obj, "#{create_method_name} returned nil"
    assert created_obj.vertices_route?, "#{create_method_name} returned #{created_obj}. Expected a vertex or vertex-route."
  end


  # Assert that the given route and array contain the same items.
  # Ignore the order of the items.
  # If there are repeated items, assert that they occur the same number of
  # times in both the array and route.
  def _assert_same_items(route, array)
    hash1 = Hash.new(0)
    route.each{|key| hash1[key] += 1}

    hash2 = Hash.new(0)
    array.each{|key| hash2[key] += 1}

    assert_equal hash1, hash2
  end


  def _get_all_comments(post)
    all_comments = []

    # Perform Breadth-First Search for comments, starting from Dave's first post
    q = [post]
    while not q.empty?
      post_or_comment = q.shift
      if (post_or_comment.nil?)
        next
      end
      all_comments += @comments[post_or_comment]
      q += @comments[post_or_comment]
    end

    all_comments
  end


end
