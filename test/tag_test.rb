require File.expand_path('../helper', __FILE__)

class TagTest < Test::Unit::TestCase
  setup do
    @client = GReader.auth credentials
    @tags   = @client.tags
    @tag    = @tags[4]
  end

  test "Client#tags" do
    assert_equal 24, @tags.size
  end

  test "Tag" do
    assert_equal "Dev | Ruby", @tag.to_s
  end

  test "Tag#feeds" do
    @feeds = @tag.feeds

    control = ["pipe :to => /dev/null", "RubyInside.com", "The timeless repository", "Antirez.com"]
    assert_equal control, @feeds.map(&:to_s)
  end

  describe "Entries" do
    setup do
      @entries = @tag.entries
      @entry   = @entries.first
    end

    test "is_a Entries" do
      assert @entries.is_a?(GReader::Entries)
    end

    test "tag entries" do
      assert @entry.is_a?(GReader::Entry)

      assert_equal "Github reviews as a way to improve code quality?", @entry.title
      assert_equal @entry.title, @entry.to_s
      assert_equal "(author unknown)", @entry.author
    end

    test "Entry#feed" do
      assert @entry.feed.is_a?(GReader::Feed)
      assert_equal @entry.feed, @client.feed(@entry.feed.id)
    end
  end
end
