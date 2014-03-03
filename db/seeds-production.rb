[
    "Internal",
    "Agency",
    "Supplier/Service Provider",
    "Nonprofit",
    "Commercial",
    "Media"
].each { |company_type| CompanyType.find_or_create_by!(name: company_type) }