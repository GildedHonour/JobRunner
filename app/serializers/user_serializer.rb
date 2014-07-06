class UserSerializer < ActiveModel::Serializer
  def attributes
    hash = super
    hash[:id] = object.id
    hash[:uuid] = object.id
    hash[:email] = object.email
    hash[:contact] = ContactSerializer.new(object.contacts.first)
    hash
  end
end
