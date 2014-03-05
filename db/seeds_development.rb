contact_job_titles = [
    "Developer",
    "Designer",
    "Project Manager",
    "Business Development",
    "Marketing Manager",
    "Sales Lead"
]

company_logos = Dir['spec/fixtures/company_logos/*']
company_types = CompanyType.all
internal_companies = Company.internal

100.times do |i|
  company = Company.create!(
      name: "#{Faker::Company.name}-#{i}",
      website: Faker::Internet.domain_name,
      company_type: company_types.sample,
      addresses: [
          Address.new(
              address_line_1: Faker::Address.street_address,
              city: Faker::Address.city,
              state: Faker::Address.us_state,
              zip: Faker::Address.zip_code
          )
      ],
      company_logo: File.open(company_logos.sample)
  )
  company.affiliates << Company.order("RANDOM()").where("id <> ?", company.id).limit(3)
  company.principals << Company.order("RANDOM()").where("id <> ?", company.id).limit(5)
  company.internal_company_relationships.create!(internal_company: internal_companies.sample, role:  InternalCompanyRelationship.role.values.sample)
end

1500.times do |i|
  Contact.create!(
      first_name: Faker::Name.first_name,
      last_name: "#{Faker::Name.last_name}-#{i}",
      emails: [Email.new(value: Faker::Internet.email)],
      phone_numbers: [PhoneNumber.new(value: Faker::PhoneNumber.phone_number)],
      addresses: [
          Address.new(
              address_line_1: Faker::Address.street_address,
              city: Faker::Address.city,
              state: Faker::Address.us_state,
              zip: Faker::Address.zip_code
          )
      ],
      job_title: contact_job_titles.sample,
      company_id: Company.order("RANDOM()").first.id
  )
end

