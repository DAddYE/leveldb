require_relative './helper'

class TestIterator < Minitest::Test

  def db
    Thread.current[:__db_iter__] ||= LevelDB::DB.new './tmp/test-iterator'
  end

  def teardown
    db.close
    db.destroy
  end

  def test_next
    db[:sten] = :smith
    db[:roger]= :smith

    p db.each.peek
  end
end
