module Audited
  extend ActiveSupport::Concern
  included do
    has_paper_trail ignore: [:created_at, :updated_at], meta: { item_descriptor: :audit_descriptor }
  end
end
