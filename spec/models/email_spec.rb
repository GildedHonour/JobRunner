require 'spec_helper'

describe Email do
  describe "associations" do
    it { should belong_to(:emailable) }
  end

  describe "validations" do
    it { should validate_presence_of(:value) }
  end
end
