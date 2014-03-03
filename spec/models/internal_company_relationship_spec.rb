require 'spec_helper'

describe InternalCompanyRelationship do
  describe "associations" do
    it { should belong_to(:company) }
    it { should belong_to(:internal_company) }
  end

  describe "validations" do
    it { should validate_presence_of(:role) }
  end
end