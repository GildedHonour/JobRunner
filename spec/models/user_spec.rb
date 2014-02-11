require 'spec_helper'

describe User do
  describe 'associations' do
    it { should have_many(:contacts) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
  end
end