class Sqids
  module Rails
    module Model
      class AlphabetError < StandardError; end

      class MinimumLengthError < StandardError; end

      extend ActiveSupport::Concern

      module ClassMethods
        # Example using #has_sqid:
        #
        #   # Schema: User(sqid:string, long_sqid:string)
        #   class User < ApplicationRecord
        #     include Sqids::Rails::Model
        #
        #     has_sqid
        #     has_sqid :long_sqid, min_length: 24
        #   end
        #
        #   user = User.new
        #   user.save
        #   user.sqid # => "lzNKgEb6ZuaU"
        #   user.sqid_long # => "4y3SVm9M2aV8Olu6p4zZoGij"
        #   user.regenerate_sqid
        #   user.regenerate_long_sqid
        #
        # +SecureRandom.random_number(Sqids.max_value)+ is used to generate the random number to encode.
        #
        # Note that it's still possible to generate a race condition in the database in the same way that
        # {validates_uniqueness_of}[https://api.rubyonrails.org/classes/ActiveRecord/Validations/ClassMethods.html#method-i-validates_uniqueness_of]
        # can. You're encouraged to add a unique index in the database to deal with this even more unlikely scenario.
        #
        # See the {Sqids Ruby}[https://github.com/sqids/sqids-ruby] documentation for more information on the options.
        #
        # === Options
        #
        # [:alphabet]
        #   The alphabet to use for encoding. Default is +Sqids::Rails.alphabet+.
        #   The minimum alphabet length is 3 characters.
        #   The alphabet cannot contain any multibyte characters.
        #
        # [:blocklist]
        #   The blocklist to use for encoding. Default is +Sqids::Rails.blocklist+.
        #
        # [:min_length]
        #   The minimum length of the generated sqid, from 0-255. Default is +Sqids::Rails.min_length+. Sqids cannot
        #   generate IDs up to a certain length, only at least a certain length.
        #
        # [:on]
        #   The callback when the value is generated. When called with <tt>on: :initialize</tt>, the value is generated
        #   in an <tt>after_initialize</tt> callback, otherwise the value will be used in a <tt>before_</tt> callback.
        #   When not specified, +:on+ will use the value of <tt>Sqids::Rails.generate_sqid_on</tt>, which defaults to
        #   +:initialize+.
        def has_sqid(
          attribute = :sqid,
          alphabet: Sqids::Rails.alphabet,
          blocklist: Sqids::Rails.blocklist,
          min_length: Sqids::Rails.min_length,
          on: Sqids::Rails.generate_sqid_on
        )
          if alphabet.length < 3
            raise AlphabetError, "Sqid requires an alphabet of at least 3 characters"
          end

          if alphabet.each_char.any? { |char| char.bytesize > 1 }
            raise AlphabetError, "Sqid alphabet cannot contain multibyte characters"
          end

          if alphabet.chars.uniq.length != alphabet.length
            raise AlphabetError, "Sqid alphabet must contain unique characters"
          end

          if min_length < 0 || min_length > 255
            raise MinimumLengthError, "Sqid requires a minimum length between 0 and 255 characters"
          end

          define_method(:"regenerate_#{attribute}") do
            update!(
              attribute => self.class.generate_unique_sqid(
                alphabet: alphabet, blocklist: blocklist, min_length: min_length
              )
            )
          end
          set_callback(on, (on == :initialize) ? :after : :before) do
            if new_record? && !query_attribute(attribute)
              send(
                :"#{attribute}=",
                self.class.generate_unique_sqid(alphabet: alphabet, blocklist: blocklist, min_length: min_length)
              )
            end
          end
        end

        def generate_unique_sqid(
          alphabet: Sqids::Rails.alphabet, blocklist: Sqids::Rails.blocklist, min_length: Sqids::Rails.min_length
        )
          @sqids ||= {}
          @sqids[[alphabet, blocklist, min_length]] ||= Sqids.new(
            alphabet: alphabet, blocklist: blocklist, min_length: min_length
          )
          @sqids[[alphabet, blocklist, min_length]].encode([SecureRandom.random_number(Sqids.max_value)])
        end
      end
    end
  end
end
