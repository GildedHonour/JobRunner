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
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.oauth_info = { info: auth.info.to_h }.merge(extra: auth.extra.raw_info.to_h)
    end
  end
end
