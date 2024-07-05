Sqids::Rails.configure do |config|
  config.min_length = Sqids::DEFAULT_MIN_LENGTH
  config.alphabet = Sqids::DEFAULT_ALPHABET
  config.blocklist = Sqids::DEFAULT_BLOCKLIST
  config.generate_sqid_on = :initialize
end
