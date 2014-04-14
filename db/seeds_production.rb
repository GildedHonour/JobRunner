[
    "Agency",
    "Commercial",
    "Internal",
    "List Broker",
    "List Manager",
    "Nonprofit",
].each { |company_type| CompanyType.find_or_create_by!(name: company_type) }

[
  "MMI Website",
  "MSL Website",
  "PMG website",
  "TEG Website"
].each { |contact_source| ContactSource.find_or_create_by!(name: contact_source) }

%w(PMG MMI TEG MSL).each do |internal_company|
  Company.create!(
    name: internal_company,
    website: Faker::Internet.domain_name,
    company_type: CompanyType.internal,
    addresses: [
      Address.new(
        address_line_1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::AddressUS.state,
        zip: Faker::AddressUS.zip_code
      )
    ]
  )
end
