require 'spec_helper'

describe CompanyType do
  describe "validations" do
    it { should validate_presence_of(:company_type) }
  end
end
