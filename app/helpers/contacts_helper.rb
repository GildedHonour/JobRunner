module ContactsHelper
  include BackForwardLinkGenerator
  include CountryStateDataSource
  
  def tooltip_text_for_filter(filter)
    {
      relationships: "Shows all contacts of a company where the company is related to the selected internal company",
      roles: "Shows all contacts of a company where the company is related to an internal company in the selected role",
      status: "Shows all contacts of a company where the company has the selected affiliation or relationship status",
      company_type: "Shows all contacts of a company where the company is of the selected type",
      birthday: "Shows contacts with the selected birthday"
    }[filter]
  end

  private

  def entity_path
    ->(id) { contact_path(id) }
  end
end