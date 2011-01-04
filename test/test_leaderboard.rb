require 'helper'
require 'mocha'

class TestLeaderboard < Test::Unit::TestCase
  def setup
    @leaderboard = Leaderboard.new('name')
  end
  
  def teardown
    @leaderboard.flush
  end
  
  def test_version
    assert_equal '1.0.0', Leaderboard::VERSION
  end
  
  def test_initialize_with_defaults  
    assert_equal 'name', @leaderboard.leaderboard_name
    assert_equal 'localhost', @leaderboard.host
    assert_equal 6379, @leaderboard.port
    assert_equal Leaderboard::DEFAULT_PAGE_SIZE, @leaderboard.page_size
  end
  
  def test_add_member
    @leaderboard.expects(:add_member).at_least_once
    @leaderboard.add_member('member', 1)
  end
  
  def test_total_members
    @leaderboard.add_member('member', 1)
    
    assert_equal 1, @leaderboard.total_members
  end

  def test_total_members_in_score_range
    @leaderboard.add_member('member_1', 1)
    @leaderboard.add_member('member_2', 2)
    @leaderboard.add_member('member_3', 3)
    @leaderboard.add_member('member_4', 4)
    @leaderboard.add_member('member_5', 5)
    
    assert_equal 3, @leaderboard.total_members_in_score_range(2, 4)
  end
  
  def test_rank_for
    @leaderboard.add_member('member_1', 1)
    @leaderboard.add_member('member_2', 2)
    @leaderboard.add_member('member_3', 3)
    @leaderboard.add_member('member_4', 4)
    @leaderboard.add_member('member_5', 5)
    
    assert_equal 1, @leaderboard.rank_for('member_4')
  end
end