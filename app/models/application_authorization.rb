class ApplicationAuthorization < ActiveRecord::Base
  belongs_to :user
  belongs_to :authorized_application
end
