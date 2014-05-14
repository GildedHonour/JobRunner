class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :website, :archived, :company_type_code

  def company_type_code
    self.object.company_type.code
  end
end