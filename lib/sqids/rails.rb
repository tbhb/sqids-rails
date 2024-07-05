require "active_support/core_ext/module/attribute_accessors"

require "sqids"
require "sqids/rails/version"
require "sqids/rails/engine"
require "sqids/rails/model"

class Sqids
  module Rails
    mattr_accessor :alphabet, default: Sqids::DEFAULT_ALPHABET
    mattr_accessor :blocklist, default: Sqids::DEFAULT_BLOCKLIST
    mattr_accessor :min_length, default: Sqids::DEFAULT_MIN_LENGTH
    mattr_accessor :generate_sqid_on, default: :initialize

    def self.configure
      yield self
    end

    def self.sqids
      @sqids ||= Sqids.new(alphabet: alphabet, blocklist: blocklist, min_length: min_length)
    end
  end
end
