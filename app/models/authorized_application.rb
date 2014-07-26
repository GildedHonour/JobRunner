class AuthorizedApplication < ActiveRecord::Base
  has_many :api_auths

  validates :name, uniqueness: true
end
