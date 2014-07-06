class User < ActiveRecord::Base
  has_paper_trail
  include Audited

  devise :invitable, :database_authenticatable, :recoverable, :trackable, :validatable, :omniauthable

  has_many :contacts

  has_many :application_authorizations, dependent: :destroy
  has_many :authorized_applications, through: :application_authorizations

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
