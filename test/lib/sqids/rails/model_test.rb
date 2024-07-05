require "test_helper"

class Sqids::Rails::ModelTest < ActiveSupport::TestCase
  setup do
    @user = User.new
  end

  test "sqid attributes are generated for specified attributes and persisted on save" do
    @user.save
    assert_not_nil @user.sqid
    assert_not_nil @user.long_sqid
    assert @user.sqid.length >= Sqids::Rails.min_length
    assert @user.long_sqid.length >= 24
  end

  test "generating sqid on initialize does not affect reading from the sqid" do
    model = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      self.table_name = "users"
      has_sqid on: :initialize
    end

    sqid = "abc123"
    user = model.create!(sqid: sqid)

    assert_equal sqid, user.sqid
    assert_equal sqid, user.reload.sqid
    assert_equal sqid, model.find(user.id).sqid
  end

  test "generating sqid on initialize happens only once" do
    model = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      self.table_name = "users"
      has_sqid on: :initialize
    end

    sqid = "      "

    user = model.new
    user.update!(sqid: sqid)

    assert_equal sqid, user.sqid
    assert_equal sqid, user.reload.sqid
    assert_equal sqid, model.find(user.id).sqid
  end

  test "generating sqid on initialize is skipped if column was not selected" do
    model = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      self.table_name = "users"
      has_sqid on: :initialize
    end

    model.create!
    assert_nothing_raised do
      model.select(:id).last
    end
  end

  test "regenerating the sqid" do
    @user.save
    old_sqid = @user.sqid
    old_long_sqid = @user.long_sqid
    @user.regenerate_sqid
    @user.regenerate_long_sqid

    assert_not_equal old_sqid, @user.sqid
    assert_not_equal old_long_sqid, @user.long_sqid

    assert @user.sqid.length >= Sqids::Rails.min_length
    assert @user.long_sqid.length >= 24
  end

  test "sqid value not overwritten when present" do
    @user.sqid = "custom-sqid"
    @user.save

    assert_equal "custom-sqid", @user.sqid
  end

  test "alphabet must be at least 3 characters" do
    assert_raises(Sqids::Rails::Model::AlphabetError) do
      @user.class_eval do
        has_sqid alphabet: "ab"
      end
    end
  end

  test "alphabet cannot contain multibyte characters" do
    assert_raises(Sqids::Rails::Model::AlphabetError) do
      @user.class_eval do
        has_sqid alphabet: "abé"
      end
    end
  end

  test "alphabet must contain unique characters" do
    assert_raises(Sqids::Rails::Model::AlphabetError) do
      @user.class_eval do
        has_sqid alphabet: "aabcdefg"
      end
    end
  end

  test "minimum length must be between 0 and 255" do
    assert_raises(Sqids::Rails::Model::MinimumLengthError) do
      @user.class_eval do
        has_sqid min_length: -1
      end
    end
    assert_raises(Sqids::Rails::Model::MinimumLengthError) do
      @user.class_eval do
        has_sqid min_length: 256
      end
    end
  end

  test "sqid on callback" do
    model = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      self.table_name = "users"
      has_sqid on: :initialize
    end

    user = model.new

    assert_predicate user.sqid, :present?
  end

  test "sqid calls the setter method" do
    model = Class.new(ApplicationRecord) do
      include Sqids::Rails::Model

      self.table_name = "users"
      has_sqid on: :initialize

      attr_accessor :modified_sqid

      def sqid=(value)
        super
        self.modified_sqid = "#{value}_modified"
      end
    end

    user = model.new

    assert_equal "#{user.sqid}_modified", user.modified_sqid
  end
end
