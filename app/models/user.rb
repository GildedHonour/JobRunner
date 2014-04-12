class User < ActiveRecord::Base
  has_paper_trail

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  has_many :contacts
end