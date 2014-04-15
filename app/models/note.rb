class Note < ActiveRecord::Base
  has_paper_trail

	belongs_to :notable, polymorphic: true
  belongs_to :user
end