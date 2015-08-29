require_relative 'ex1.rb'
require_relative 'util.rb'


class TestCases < BaseTestSuite

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
