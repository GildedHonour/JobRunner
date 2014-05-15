module Audited
  extend ActiveSupport::Concern
  included do
    has_paper_trail ignore: [:created_at, :updated_at], meta: {
        item_descriptor:      Proc.new { |object| object.audit_meta[:item_descriptor] },
        item_root_class:      Proc.new { |object| object.audit_meta[:item_root_class].to_s },
        item_root_object_id:  Proc.new { |object| object.audit_meta[:item_root_object_id] }
    }
  end
end
