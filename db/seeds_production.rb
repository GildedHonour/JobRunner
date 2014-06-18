[
  "Admin",
  "Agency",
  "Commercial Mailer",
  "Data Services",
  "Fulfillment/Mail Processing",
  "Internal",
  "List Broker",
  "List Manager",
  "Nonprofit",
  "Mailshop",
  "Media/Trade Groups",
  "Printer"
].each { |company_type| CompanyType.find_or_create_by!(name: company_type, code: company_type.underscore.gsub(" ", "_")) }

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
        state: get_random_usa_state_short_name,
        zip: Faker::AddressUS.zip_code
      )
    ]
  )
end
