require 'spec_helper'

describe PhoneNumber do
  describe "associations" do
    it { should belong_to(:phonable) }
  end

  describe "validations" do
    it { should validate_presence_of(:value) }
  end
end
