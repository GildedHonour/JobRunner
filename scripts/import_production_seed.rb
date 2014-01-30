require 'csv'

def company_value(country)
  Address.country.values.include?(country.to_s.downcase) ? country.to_s.downcase : :usa
end

def affiliation_role_value(value)
  value.gsub(" ", "_").downcase
end

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

mmi = Company.create!(name: "MMI", internal: true)
msl = Company.create!(name: "MSL", internal: true)
pmg = Company.create!(name: "PMG", internal: true)
teg = Company.create!(name: "TEG", internal: true)

User.create!(email: 'sean@engageyourcause.com', password: 'password')
User.create!(email: 'projects@akshay.cc', password: 'password')

import_file = "spec/fixtures/export_data.csv"
row_number = 1

CSV.foreach(import_file, encoding: "windows-1251:utf-8", headers: true) do |row|
  company =           row[0]
  prefix =            row[1]
  first_name =        row[2]
  middle_name =       row[3]
  last_name =         row[4]
  suffix =            row[5]
  job_title =         row[6]
  address_line_1 =    row[7]
  city =              row[8]
  state =             row[9]
  zip =               row[10]
  country =           row[11]

  business_phone =    row[12]
  mobile_phone =      row[13]
  fax_phone =         row[14]
  home_phone =        row[15]
  other_phone =       row[16]
  other_fax =         row[17]

  email_address =     row[18]
  website =          row[19]

  teg_contact =       row[20]
  teg_role =          row[21]
  teg_status =        row[22]

  mmi_contact =       row[23]
  mmi_role =          row[24]
  mmi_status =        row[25]

  pmg_contact =       row[26]
  pmg_role =          row[27]
  pmg_status =        row[28]

  msl_contact =       row[29]
  msl_role =          row[30]
  msl_status =        row[31]

  birth_day =         row[32]
  birth_month =       row[33]

  cookies =           row[34]
  mmi_ballgame =      row[35]
  do_not_email =       row[36]
  do_not_mail =       row[37]

  teg_source =        row[40]
  mmi_source =        row[41]
  pmg_source =        row[42]
  msl_source =        row[43]

  puts "Row: #{row_number+=1} - #{pmg_role}"

  (ap "No company on row #{row_number}" && next) if company.blank?

  company = Company.where(name: company).first || Company.create(
    name: company,
    website: website,
    addresses_attributes:     [{ address_line_1: address_line_1, city: city, country: company_value(country), state: state, zip: zip }],
    phone_numbers_attributes: [
      { value: business_phone, kind: :business    },
      { value: mobile_phone,   kind: :mobile      },
      { value: fax_phone,      kind: :fax         },
      { value: home_phone,     kind: :home        },
      { value: other_phone,    kind: :other_phone },
      { value: other_fax,      kind: :other_fax   }
    ]
  )

  if(first_name.blank?)
    ap "No contact on row #{row_number-1}"
  else
    company.contacts.create!(
      prefix: prefix,
      birthday: (Date.parse("#{birth_day} #{birth_month}") if(birth_day.present? && birth_month.present?)),
      first_name: first_name,
      middle_name: middle_name,
      last_name: last_name,
      job_title: job_title,
      mmi_ballgame: mmi_ballgame,
      do_not_email: do_not_email.downcase == "true",
      do_not_mail: do_not_mail.downcase == "true",
    )
  end

  if(teg_contact.to_s.downcase == "true")
    Affiliation.create!(principal: teg, affiliate: company, role: affiliation_role_value(teg_role)) if Affiliation.where(principal_id: teg, affiliate_id: company, role: affiliation_role_value(teg_role)).blank?
  elsif(mmi_contact.to_s.downcase == "true")
    Affiliation.create!(principal: mmi, affiliate: company, role: affiliation_role_value(mmi_role)) if Affiliation.where(principal_id: mmi, affiliate_id: company, role: affiliation_role_value(mmi_role)).blank?
  elsif(pmg_contact.to_s.downcase == "true")
    Affiliation.create!(principal: pmg, affiliate: company, role: affiliation_role_value(pmg_role)) if Affiliation.where(principal_id: pmg, affiliate_id: company, role: affiliation_role_value(pmg_role)).blank?
  elsif(msl_contact.to_s.downcase == "true")
    Affiliation.create!(principal: msl, affiliate: company, role: affiliation_role_value(msl_role)) if Affiliation.where(principal_id: msl, affiliate_id: company, role: affiliation_role_value(msl_role)).blank?
  end
end

ap "No. of companies created: #{Company.count}"
ap "No. of companies created: #{Contact.count}"
ap "No. of affiliations created: #{Affiliation.count}"
