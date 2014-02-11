class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  has_many :contacts
end