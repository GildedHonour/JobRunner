module CompaniesHelper
  def tooltip_text_for_filter(filter)
    {
      relationships: "Shows companies related to the selected internal company",
      roles: "Shows companies related to any internal company in the selected role",
      status: "Shows companies with the selected affiliation or relationship status",
      company_type: "Shows companies of the selected type",
      affiliations_of: "Shows companies which are affiliated to the selected company"
    }[filter]
  end
end