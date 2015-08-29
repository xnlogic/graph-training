require_relative 'ex1-solution.rb'
require_relative 'ex2.rb'
require_relative 'util.rb'


class TestCases < BaseTestSuite

  def test_get_person_by_name
    name = :Alice
    alice = get_person_by_name(@g, name)
    refute_nil alice, "Could not find a person whose name is #{name}"
    assert alice.vertices_route?, "The returned person is not a vertex, it is #{alice}"
    assert alice[:name] == name, "Expected '#{name}', got #{alice[:name]}"
  end

  def test_get_person_by_non_existing_name
    name = :NoSuchName
    assert_nil get_person_by_name(@g, name)
  end


  def test_get_posts_and_comments_by
    r = get_posts_and_comments_by(get_person_by_name(@g, :Bob))
    _assert_same_items r[:text], ["Bob's only post!", 'Bar', 'Comment 1']
  end

  def test_get_posts_and_comments_by
    r = get_posts_and_comments_by(get_person_by_name(@g, :Bob))
    _assert_same_items r[:text], ["Bob's only post!", 'Bar', 'Comment 1']
  end


  def test_get_recent_posts_and_comments
    @g.v(type: Set['post','comment']).each do |post_or_comment|
      post_or_comment[:timestamp] = Time.now - 60 * 60 * 24 - 7
    end

    assert_equal 0, get_recent_posts_and_comments(@g).count
  end


  def test_get_recent_posts_and_comments
    @g.v(type: Set['post','comment']).each do |post_or_comment|
      post_or_comment[:timestamp] = Time.now - 60 * 60 * 24 - 7
    end

    v = @g.v(type: Set['post','comment']).first
    v[:timestamp] = Time.now

    assert_equal 1, get_recent_posts_and_comments(@g).count
    assert_equal v, get_recent_posts_and_comments(@g).first
  end


  def test_active_people
    _assert_same_items active_people(@g), [@people[:Alice], @people[:Dave]]
  end


  def test_most_active_person
    assert_equal @people[:Alice], most_active_person(@g)
  end

  def test_most_active_person_2
    get_posts_and_comments_by(get_person_by_name(@g, :Alice)).each do |v|
      v[:timestamp] = Time.now - 60 * 60 * 24 * 1 - 7
    end
    assert_equal @people[:Dave], most_active_person(@g)
  end

end
