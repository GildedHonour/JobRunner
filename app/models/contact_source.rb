class ContactSource < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  scope :ordered_by_name, -> { order("contact_sources.name") }

  def to_s
    self.name
  end
end
