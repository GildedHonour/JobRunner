require 'csv'

def company_value(country)
  Address.country.values.include?(country.to_s.downcase) ? country.to_s.downcase : :usa
end

def company_type_value(company_type_string)
  return nil if company_type_string.blank?
  ct = CompanyType.where(name: company_type_string).first
  raise "No company type found for #{company_type_string}" if ct.blank?
  ct
end

def phone_number_attributes(kind, phone_number_string)
  return {} if phone_number_string.blank?

  phone_number_string.gsub!(/^\+1\s/, "")

  digits = phone_number_string.split("").select{|b|b=~ /\d/}
  raise "invalid phone #{phone_number_string} - #{digits.size} and #{digits}" unless [10, 12, 13, 14].include?(digits.size)

  attributes = { kind: kind, phone_number: "(#{digits[0..2].join}) #{digits[3..5].join}-#{digits[6..10].join}" }
  attributes.merge!({ extension: "#{digits[11..14].join}" }) if digits.size >= 12
  attributes
end

def internal_relationship_role_value(value)
  value.gsub(/\.|\(|\)|\-|\s/, "").downcase
end

def parse_boolean(string)
  %w(true 1 y).include?(string.to_s.downcase.strip)
end

mmi = Company.where(name: "MMI").first
msl = Company.where(name: "MSL").first
pmg = Company.where(name: "PMG").first
teg = Company.where(name: "TEG").first


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

  email =             row[18]
  website =           row[19]

  company_type =      row[20]
  contest_participant = row[21]
  source =            row[22]

  teg_status =        row[23]
  teg_role =          row[24]

  mmi_status =        row[25]
  mmi_role =          row[26]

  pmg_status =        row[27]
  pmg_role =          row[28]

  msl_status =        row[29]
  msl_role =          row[30]

  birth_day =         row[31]
  birth_month =       row[32]

  send_cookies =      row[33]
  mmi_ballgame =      row[34]
  do_not_email =      row[35]
  do_not_mail =       row[36]

  id =                row[37]
  note =              row[38]

  inactive_contact =  row[43]

  puts "Row: #{row_number+=1}"

  (ap "No company on row #{row_number}" && next) if company.blank?

  company = Company.where(name: company).first || Company.create!(
    company_type: company_type_value(company_type),
    name: company,
    website: website,
    addresses_attributes:     [{ address_line_1: address_line_1, city: city, country: company_value(country), state: state, zip: zip }]
  )

  if(first_name.blank?)
    ap "No contact on row #{row_number-1}"
  else
    ap "Importing contact #{first_name} - #{last_name} #{row_number-1}"
    company.contacts.create!(
      addresses_attributes: [{ address_line_1: address_line_1, city: city, country: company_value(country), state: state, zip: zip }],
      birthday: (Date.parse("#{birth_day} #{birth_month}") if(birth_day.present? && birth_month.present?)),
      do_not_email: parse_boolean(do_not_email),
      do_not_mail: parse_boolean(do_not_mail),
      contest_participant: parse_boolean(contest_participant),
      send_cookies: parse_boolean(send_cookies),
      emails_attributes: [{ value: email }],
      first_name: first_name,
      job_title: job_title,
      last_name: last_name,
      middle_name: middle_name,
      mmi_ballgame: mmi_ballgame,
      phone_numbers_attributes: [
          phone_number_attributes(:business, business_phone),
          phone_number_attributes(:mobile, mobile_phone),
          phone_number_attributes(:fax, fax_phone),
          phone_number_attributes(:home, home_phone),
          phone_number_attributes(:other_phone, other_phone),
          phone_number_attributes(:other_fax, other_fax),
      ],
      archived: parse_boolean(inactive_contact),
      notes: [ Note.new(note: note) ],
      prefix: prefix
    )
  end

  if teg_role.present?
    InternalCompanyRelationship.create!(internal_company: teg, company: company, role: internal_relationship_role_value(teg_role), archived: !(teg_status.to_s.downcase.strip == "active")) if InternalCompanyRelationship.where(internal_company_id: teg, company_id: company, role: internal_relationship_role_value(teg_role)).blank?
  end
  if mmi_role.present?
    InternalCompanyRelationship.create!(internal_company: mmi, company: company, role: internal_relationship_role_value(mmi_role), archived: !(mmi_status.to_s.downcase.strip == "active")) if InternalCompanyRelationship.where(internal_company_id: mmi, company_id: company, role: internal_relationship_role_value(mmi_role)).blank?
  end
  if pmg_role.present?
    InternalCompanyRelationship.create!(internal_company: pmg, company: company, role: internal_relationship_role_value(pmg_role), archived: !(pmg_status.to_s.downcase.strip == "active")) if InternalCompanyRelationship.where(internal_company_id: pmg, company_id: company, role: internal_relationship_role_value(pmg_role)).blank?
  end
  if msl_role.present?
    InternalCompanyRelationship.create!(internal_company: msl, company: company, role: internal_relationship_role_value(msl_role), archived: !(msl_status.to_s.downcase.strip == "active")) if InternalCompanyRelationship.where(internal_company_id: msl, company_id: company, role: internal_relationship_role_value(msl_role)).blank?
  end
end

ap "No. of companies created: #{Company.count}"
ap "No. of companies created: #{Contact.count}"
ap "No. of affiliations created: #{InternalCompanyRelationship.count}"
