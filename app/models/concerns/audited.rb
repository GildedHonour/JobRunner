module Audited
  extend ActiveSupport::Concern
  included do
    has_paper_trail ignore: [
      :created_at, :updated_at, :last_sign_in_at, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :sign_in_count,
      :encrypted_password, :invitation_token, :reset_password_token
    ], meta: {
        item_descriptor:      Proc.new { |object| object.audit_meta[:item_descriptor] },
        item_root_class:      Proc.new { |object| object.audit_meta[:item_root_class].to_s },
        item_root_object_id:  Proc.new { |object| object.audit_meta[:item_root_object_id] }
    }
  end
end
