require 'spec_helper'

describe Company do
  describe "associations" do
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end