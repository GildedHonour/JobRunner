require 'spec_helper'

describe Address do
  describe "associations" do
    it { should belong_to(:addressable) }
  end

  describe "validations" do
    it { should validate_presence_of(:address_line_1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
  end
end
