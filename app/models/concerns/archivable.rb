module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archived, where(archived: true)
  end

  def record_status
    self.archived? ? "Inactive" : "Active"
  end
end