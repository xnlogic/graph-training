require_relative 'ex1-solution.rb'
require_relative 'ex3.rb'
require_relative 'util.rb'


class TestCases < BaseTestSuite


  def test_posted_something
    people = @g.v(type: 'person', name: Set[:Alice, :Charlie])
    _assert_same_items posted_something(people), [@people[:Alice]]
  end

  def test_popular_posts
    _assert_same_items popular_posts(@g.v(type: 'post')), [ @posts[:Dave][0] ]
  end

  def test_unpopular_people
    people = @g.v(type: 'person', name: Set[:Alice, :Dave])
    assert_equal 1, unpopular_people(people).count
    assert_equal @people[:Alice], unpopular_people(people).first
  end

  def test_unpopular_people_2
    people = @g.v(type: 'person', name: Set[:Alice, :Dave])
    create_comment(@g, @people[:Bob], @posts[:Alice][0],
                   "Another comment will make Alice popular")

    assert_equal 0, unpopular_people(people).count
  end

end
