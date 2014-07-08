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

  def authorized_for_application?(application_name)
    return false if application_name.blank?

    self.authorized_applications.exists?(name: application_name)
  end

  def force_logout!
    self.update_attributes!({ force_logout: true })
  end

  def process_login!(cas_service_ticket)
    self.update_attributes({ cas_service_ticket: cas_service_ticket, force_logout: false })
  end

  def self.from_omniauth(auth)
    find_by_id(auth[:extra][:uuid])
  end
end
