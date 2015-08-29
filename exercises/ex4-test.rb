require_relative 'ex1-solution.rb'
require_relative 'ex4-solution.rb'
require_relative 'util.rb'


class TestCases < BaseTestSuite

  def test_get_people_who_commented_on_my_posts
    _assert_same_items  get_people_who_commented_on_my_posts(@people[:Alice]),
                        [ @people[:Bob], @people[:Charlie] ]
  end

  def test_get_people_who_commented_on_my_posts_with_a_route
    r = @g.v(type: 'person', name: :Alice)
    _assert_same_items  get_people_who_commented_on_my_posts(r),
                        [ @people[:Bob], @people[:Charlie] ]
  end


  def test_get_comments_about_my_posts_from_other_people
    actual = get_comments_about_my_posts_from_other_people(@people[:Alice])

    expected = []
    @posts[:Alice].each do |post|
      @comments[post].each do |comment|
        expected.push comment
      end
    end

    _assert_same_items actual, expected
  end


  def test_get_comments_about_my_posts_from_other_people_2
    actual = get_comments_about_my_posts_from_other_people(@people[:Alice])

    expected = []
    @posts[:Alice].each do |post|
      @comments[post].each do |comment|
        expected.push comment
      end
    end

    create_comment(@g, @people[:Alice], @posts[:Alice][0],
          "This comment should NOT be included in the result.")

    _assert_same_items actual, expected
  end


  def test_get_comments_about_my_posts_from_other_people_with_a_route
    r = @g.v(type: 'person', name: :Alice)
    actual = get_comments_about_my_posts_from_other_people(r)

    expected = []
    @posts[:Alice].each do |post|
      @comments[post].each do |comment|
        expected.push comment
      end
    end

    _assert_same_items actual, expected
  end


  def test_get_comments_about_my_posts_from_other_people_2_with_a_route
    r = @g.v(type: 'person', name: :Alice)
    actual = get_comments_about_my_posts_from_other_people(r)

    expected = []
    @posts[:Alice].each do |post|
      @comments[post].each do |comment|
        expected.push comment
      end
    end

    create_comment(@g, @people[:Alice], @posts[:Alice][0],
          "This comment should NOT be included in the result.")

    _assert_same_items actual, expected
  end



end
