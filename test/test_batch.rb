require_relative './helper'

class TestBatch < Minitest::Test
  attr_reader :db

  def setup
    @db ||= LevelDB::DB.new './tmp/test-batch'
  end

  def teardown
    db.close
    db.destroy
  end

  def test_batch
    batch = db.batch
    ('a'..'z').each do |l|
      refute db[l]
      batch.put l, l.upcase
    end

    batch.write!

    ('a'..'z').each do |l|
      assert batch.delete l
      assert_equal l.upcase, db[l]
    end

    batch.write!

    ('a'..'z').each { |l| refute db[l] }
  end

  def test_batch_block
    ('a'..'z').each { |l| refute db[l] }

    db.batch do |batch|
      ('a'..'z').each { |l| batch.put l, l.upcase }
    end

    ('a'..'z').each { |l| assert_equal l.upcase, db[l] }
  end
end
