class User < ApplicationRecord
  include Sqids::Rails::Model

  has_sqid
  has_sqid :long_sqid, min_length: 24
end
