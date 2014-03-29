contact_job_titles = [
    "Developer",
    "Designer",
    "Project Manager",
    "Business Development",
    "Marketing Manager",
    "Sales Lead"
]

company_logos = Dir['spec/fixtures/company_logos/*']
company_types = CompanyType.not_internal
internal_companies = Company.internal

80.times do |i|
  company = Company.create!(
      name: "#{Faker::Company.name}",
      website: Faker::Internet.domain_name,
      company_type: company_types.sample,
      phone_numbers: [PhoneNumber.new(phone_number: Faker.numerify("(###) ###-####"))],
      addresses: [
          Address.new(
              address_line_1: Faker::Address.street_address,
              address_line_2: Faker::Address.street_name,
              city: Faker::Address.city,
              state: Faker::Address.us_state,
              zip: Faker::Address.zip_code
          )
      ],
      company_logo: File.open(company_logos.sample)
  )
  Company.order("RANDOM()").where("id NOT IN (?)", internal_companies.map(&:id) + [company.id]).limit(3).each do |affiliate|
    company.affiliate_affiliations.create(affiliate: affiliate, role: Affiliation.role.values.sample)
  end

  company.principals << Company.order("RANDOM()").where("id NOT IN (?)", internal_companies.map(&:id) + [company.id]).limit(3)

  internal_companies.sample(2).each do |internal_company|
    company.internal_company_relationships.create!(internal_company: internal_company, role:  InternalCompanyRelationship.role.values.sample)
  end
end

300.times do |i|
  Contact.create!(
      first_name: Faker::Name.first_name,
      last_name: "#{Faker::Name.last_name}",
      prefix: Contact.prefix.values.sample,
      birthday: (rand(11) + 1).months.ago - (30 + rand(10)).years,
      job_title: "Project Manager",
      emails: [Email.new(value: Faker::Internet.email)],
      phone_numbers: [PhoneNumber.new(phone_number: Faker.numerify("(###) ###-####"))],
      addresses: [
          Address.new(
              address_line_1: Faker::Address.street_address,
              address_line_2: Faker::Address.street_name,
              city: Faker::Address.city,
              state: Faker::Address.us_state,
              zip: Faker::Address.zip_code
          )
      ],
      job_title: contact_job_titles.sample,
      company_id: Company.order("RANDOM()").first.id
  )
end

