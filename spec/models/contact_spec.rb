require 'spec_helper'

describe Contact do
  describe "associations" do
    it { should belong_to(:company) }
    it { should have_many(:addresses) }
    it { should serialize(:emails).as(Email) }
    it { should serialize(:phone_numbers).as(PhoneNumber) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end
end