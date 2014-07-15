class ContactSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :prefix, :job_title, :full_name
end
