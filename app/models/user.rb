class User < ActiveRecord::Base
  has_paper_trail
  include Audited

  devise :invitable, :database_authenticatable, :recoverable, :trackable, :validatable, :omniauthable

  has_many :contacts

  def audit_meta
    {
        item_descriptor: "user for #{contacts.first.audit_meta[:item_descriptor]}",
        item_root_class: contacts.first.class,
        item_root_object_id: contacts.first.id
    }
  end

  def self.from_omniauth(auth)
    find_by_id(auth[:extra][:uuid])
  end
end
