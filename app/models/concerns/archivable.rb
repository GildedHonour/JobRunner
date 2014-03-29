module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archived, where(archived: true)
  end

  def record_status
    self.archived? ? "Inactive" : "Active"
  end

  module ClassMethods
    def with_archived_status(archived)
      where(archived: archived.to_s == "true")
    end
  end
end