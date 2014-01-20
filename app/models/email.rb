class Email < ActiveRecord::Base
  belongs_to :emailable, polymorphic: true
  validates :value, presence: true
end
