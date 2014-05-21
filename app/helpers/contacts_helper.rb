module ContactsHelper
  include BackForwardLinkGenerator
  
  def tooltip_text_for_filter(filter)
    {
      relationships: "Shows all contacts of a company where the company is related to the selected internal company",
      roles: "Shows all contacts of a company where the company is related to an internal company in the selected role",
      status: "Shows all contacts of a company where the company has the selected affiliation or relationship status",
      company_type: "Shows all contacts of a company where the company is of the selected type",
      birthday: "Shows contacts with the selected birthday"
    }[filter]
  end

  def country_state_list_user_friendly
    Address.country_state_list.map do |item| 
      item.map do |x|
        if x.is_a?(Array)
          # state or province
          x.map { |x2| [x2.to_s.capitalize.gsub(/[_]/, " "), x2.to_s] } 
        else
          # country
          x.to_s.upcase
        end
      end
    end
  end

  private

  def entity_path
    ->(id) { contact_path(id) }
  end
end