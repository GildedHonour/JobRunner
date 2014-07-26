class ApiAuth < ActiveRecord::Base
  belongs_to :authorized_application
end