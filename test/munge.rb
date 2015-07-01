require "test/unit"
require "./lib/munge.rb"

include Munger

class TestIndex < Test::Unit::TestCase

  def setup
    @dwarf_index = Index.new({
      "sleepy"  => 1,
      "sneezy"  => 2,
      "bashful" => 3,
      "doc"     => 4,
      "happy"   => 5,
      "grumpy"  => 6,
      "dopey"   => 7
    })
  end

  def test_index_exists
    assert(@dwarf_index, "Index exists")
  end

  def test_position
    assert_equal(5, @dwarf_index.position("happy"), "Gets correct element from index")
  end

  def test_value
    assert_equal("grumpy", @dwarf_index.value(6))
  end

  def test_neighbours
    assert_equal([nil, 'sneezy'], @dwarf_index.neighbours('sleepy'),
      "Correct neighbours for head")

    assert_equal(['sneezy', 'doc'], @dwarf_index.neighbours('bashful'),
      "Correct neighbours for median element")

    assert_equal(['grumpy', nil], @dwarf_index.neighbours('dopey'),
      "Correct neighbours for tail")
  end
end
