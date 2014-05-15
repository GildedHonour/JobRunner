class User < ActiveRecord::Base
  has_paper_trail
  include Audited

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  has_many :contacts

  def audit_meta
    {
        item_descriptor: "user for #{contacts.first.audit_meta[:item_descriptor]}",
        item_root_class: contacts.first.class,
        item_root_object_id: contacts.first.id
    }
  end
end
