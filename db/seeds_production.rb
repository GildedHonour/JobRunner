[
    "Internal",
    "Agency",
    "Supplier/Service Provider",
    "Nonprofit",
    "Commercial",
    "Media"
].each { |company_type| CompanyType.find_or_create_by!(name: company_type) }

%w(PMG MMI TEG MSL).each do |internal_company|
  Company.create!(
    name: internal_company,
    website: Faker::Internet.domain_name,
    company_type: CompanyType.internal,
    addresses: [
      Address.new(
        address_line_1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.us_state,
        zip: Faker::Address.zip_code
      )
    ]
  )
end

Contact.create!(
    first_name: "Sean",
    last_name: "Powell",
    prefix: "Mr.",
    job_title: "Project Manager",
    user: User.new(email: 'sean@engageyourcause.com', password: 'password'),
    company: Company.all.sample
)

Contact.create!(
    first_name: "Akshay",
    last_name: "Rawat",
    prefix: "Mr.",
    job_title: "Developer",
    user: User.new(email: 'projects@akshay.cc', password: 'password'),
    company: Company.all.sample
)

Contact.create!(
    first_name: "Lori",
    last_name: "Barao",
    prefix: "Ms.",
    job_title: "Project Manager",
    user: User.new(email: 'lori@mmidirect.com', password: 'password'),
    company: Company.all.sample
)
