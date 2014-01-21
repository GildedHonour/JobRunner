class Email < ActiveRecord::Base
  belongs_to :emailable, polymorphic: true, touch: true
  validates :value, presence: true

  def to_s
    self.value
  end
end
