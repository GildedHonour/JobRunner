require 'spec_helper'

describe Company do
  describe "associations" do
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_many(:contacts).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'affiliations' do
    it 'should save and load affiliations' do
      teg = create(:company, name: 'The Engage Group')
      pmg = create(:company, name: 'PMG')
      avalon = create(:company, name: 'Avalon')
      lwv = create(:company, name: 'League of Women Voters')

      teg.client_affiliates << pmg #This could be a internal company affiliate if needed.

      pmg.client_affiliates << avalon
      pmg.prospect_affiliates << lwv

      teg.reload; pmg.reload; avalon.reload; lwv.reload # Reload from DB to disregard un-saved, in-memory references.

      expect(teg.affiliates).to eq([pmg])
      expect(teg.client_affiliates).to eq([pmg])
      expect(teg.prospect_affiliates).to be_blank
      expect(teg.principals).to be_blank

      expect(pmg.principals).to eq([teg])
      expect(pmg.client_principals).to eq([teg])
      pmg.affiliates.should =~ [avalon, lwv]
      expect(pmg.client_affiliates).to eq([avalon])
      expect(pmg.prospect_affiliates).to eq([lwv])

      expect(avalon.principals).to eq([pmg])
      expect(avalon.client_principals).to eq([pmg])
      expect(avalon.prospect_principals).to be_blank
      expect(avalon.affiliates).to be_blank

      expect(lwv.principals).to eq([pmg])
      expect(lwv.prospect_principals).to eq([pmg])
      expect(lwv.client_principals).to be_blank
      expect(lwv.affiliates).to be_blank
    end
  end
end