module CountryStateDataSource
  def country_state_data_source
    Address.country_state_list.map do |item| 
      item.map do |x|
        if x.is_a?(Array)
          # state or province
          x.map { |x2| [x2.to_s.titleize.gsub(/[_]/, " "), x2.to_s] } 
        else
          # country
          x.to_s.upcase
        end
      end
    end
  end

  def country_state_select(form_item, css_entity_type_class)
    content_tag(:div, class: "form-group select optional #{css_entity_type_class}_addresses_country") do
      content_tag(:div) do
        form_item.select(:state, grouped_options_for_select(country_state_data_source, 
          form_item.try(:object).try(:state).try(:to_sym)), { }, 
          label: false, class: "select optional form-control user-success"
        )
      end
    end
    # .col-md-6
    #   .form-group.select.optional.company_addresses_country
    #     %div
    #       = form_item.select(:state, grouped_options_for_select(country_state_data_source, form_item.try(:object).try(:state).try(:to_sym)), {}, label: false, class: "select optional form-control user-success")
  end
end