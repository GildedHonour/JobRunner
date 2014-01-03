class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

# Provides dynamic helpers like current_user or user_signed_in?, when devise_for is not used.
Devise.add_mapping(:user, {})