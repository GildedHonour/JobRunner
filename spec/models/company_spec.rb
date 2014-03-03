require 'spec_helper'

describe Company do
  describe "associations" do
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
    it { should have_many(:internal_companies) }
    it { should belong_to(:company_type) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end