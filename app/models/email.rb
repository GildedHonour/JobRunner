class Email < ActiveRecord::Base
  has_paper_trail

  belongs_to :emailable, polymorphic: true, touch: true
  validates :value, presence: true

  def to_s
    self.value
  end
end
