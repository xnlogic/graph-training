gem "minitest"
require 'minitest/autorun'
require 'pacer'
require 'part2-exercise.rb'


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



class TestPart2Exercise < Minitest::Test


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



  #=============================================================================
  # Test cases
  # ----------
  #
  # NOTE: Methods that start with 'test_' get run automatically by MiniTest
  #=============================================================================

  #-----------------------------------------------------------------------------
  # Test that the create_XXX methods return a vertex

  def test_create_person_return_type
    _assert_is_vertex_or_vertex_route @people[:Alice], "create_person"
  end

  def test_create_post_return_type
    _assert_is_vertex_or_vertex_route @posts[:Alice][0], "create_post"
  end

  def test_create_comment_return_type
    post = @posts[:Alice][0]
    comment = @comments[post][0]
    _assert_is_vertex_or_vertex_route comment, "create_comment"
  end

  #-----------------------------------------------------------------------------
  # Test that the create_XXX methods set properties properly

  def test_create_person_sets_the_name
    assert_equal :Alice, @people[:Alice][:name]
  end

  def test_create_post_sets_the_text
    post = @posts[:Alice][0]
    assert_equal 'Foo', post[:text]
  end

  def test_create_post_sets_the_timestamp_property
    post = @posts[:Alice][0]
    assert_kind_of Time, post[:timestamp], "Expected 'timestamp' to be a Time object, but it is #{post[:timestamp].class}."
    assert_in_delta Time.now, post[:timestamp], 3, "Expected 'timestamp' to be within 3 seconds of #{Time.now}, but it is #{post[:timestamp]}."
  end

  def test_create_comment_sets_the_text
    post = @posts[:Alice][0]
    comment = @comments[post][0]
    assert_equal 'Bar', comment[:text]
  end

  def test_create_comment_sets_the_timestamp_property
    post = @posts[:Alice][0]
    comment = @comments[post][0]

    assert_kind_of Time, comment[:timestamp], "Expected 'timestamp' to be a Time object, but it is #{comment[:timestamp].class}."
    assert_in_delta Time.now, comment[:timestamp], 3, "Expected 'timestamp' to be within 3 seconds of #{Time.now}, but it is #{comment[:timestamp]}."
  end


  #-----------------------------------------------------------------------------
  # Test the return type of the get_XXX methods

  def test_get_posts_return_type
    _assert_is_vertex_or_vertex_route get_posts(@people[:Alice]), 'get_posts'
  end

  def test_get_comments_return_type
    _assert_is_vertex_or_vertex_route get_comments(@posts[:Alice][0]), 'get_comments'
  end

  def test_get_comments_on_person_posts_return_type
    comments = get_comments_on_person_posts @people[:Alice]
    _assert_is_vertex_or_vertex_route comments, 'get_comments_on_person_posts'
  end

  def test_get_fans_return_type
    _assert_is_vertex_or_vertex_route get_fans(@people[:Alice]), 'get_fans'
  end

  def test_get_fans_posts_return_type
    _assert_is_vertex_or_vertex_route get_fans_posts(@people[:Alice]), 'get_fans_posts'
  end

  def test_get_fans_of_fans_return_type
    _assert_is_vertex_or_vertex_route get_fans_of_fans(@people[:Alice]), 'get_fans_of_fans'
  end

  def test_get_fans_of_fans_return_type
    _assert_is_vertex_or_vertex_route get_fans_of_fans(@people[:Alice]), 'get_fans_of_fans'
  end

  def test_get_all_comments_return_type
    all_comments = get_all_comments(@posts[:Dave][0])
    assert all_comments.is_a? Array
    if all_comments.length > 0
      _assert_is_vertex_or_vertex_route all_comments[0], 'get_all_comments'
    end
  end


  #-----------------------------------------------------------------------------
  # Test the return type of the get_XXX methods, when the argument is a route
  # (as opposed to a single vertex)


  def test_get_posts_return_type__with_route_arg
    _assert_is_vertex_or_vertex_route get_posts(@g.v(name: :Alice)), 'get_posts'
  end

  def test_get_comments_on_person_posts_return_type__with_route_arg
    comments = get_comments_on_person_posts @g.v(name: :Alice)
    _assert_is_vertex_or_vertex_route comments, 'get_comments_on_person_posts'
  end

  def test_get_fans_return_type__with_route_arg
    _assert_is_vertex_or_vertex_route get_fans(@g.v(name: :Alice)), 'get_fans'
  end

  def test_get_fans_posts_return_type__with_route_arg
    _assert_is_vertex_or_vertex_route get_fans_posts(@g.v(name: :Alice)), 'get_fans_posts'
  end

  def test_get_fans_of_fans_return_type__with_route_arg
    _assert_is_vertex_or_vertex_route get_fans_of_fans(@g.v(name: :Alice)), 'get_fans_of_fans'
  end

  def test_get_fans_of_fans_return_type__with_route_arg
    _assert_is_vertex_or_vertex_route get_fans_of_fans(@g.v(name: :Alice)), 'get_fans_of_fans'
  end



  #-----------------------------------------------------------------------------
  # Test the actual values returned by the various get_XXX methods.




  def test_get_posts_basic
    _assert_same_items @posts[:Alice], get_posts(@people[:Alice])
  end



  def test_get_comments_of_a_post
    post = @posts[:Alice][0]
    _assert_same_items @comments[post], get_comments(post)
  end



  def test_get_comments_on_person_posts
    comments = []
    @posts[:Alice].each {|post| comments += @comments[post]}

    _assert_same_items comments, get_comments_on_person_posts(@people[:Alice])
  end


  def test_get_fans
    _assert_same_items [@people[:Bob], @people[:Charlie]], get_fans(@people[:Alice])
  end


  def test_get_fans_posts
    posts = []
    [:Bob, :Charlie].each { |fan_name| posts += @posts[fan_name] }

    _assert_same_items posts, get_fans_posts(@people[:Alice])
  end


  def test_get_fans_of_fans
    _assert_same_items [@people[:Dave]], get_fans_of_fans(@people[:Alice])
  end


  def test_get_all_comments
    post = @posts[:Dave][0]
    _assert_same_items _get_all_comments(post), get_all_comments(post)
  end


  def test_get_posts_and_get_all_comments_together
    post = @posts[:Dave][0]
    # This test assumes that Dave has only one post
    _assert_same_items _get_all_comments(post), get_all_comments(get_posts(@people[:Dave]))
  end



end
