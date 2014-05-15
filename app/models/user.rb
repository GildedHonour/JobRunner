class User < ActiveRecord::Base
  has_paper_trail
  include Audited

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  has_many :contacts

  def audit_descriptor
    "user for #{contacts.first.audit_descriptor}"
  end
end
