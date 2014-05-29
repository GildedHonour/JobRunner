module CountryStateDataSource
  def country_state_data_source
    cds_raw = Address.country_state_list.map do |x| 
      x.map do |x1, y1|
        [x1.to_s.upcase, y1.map { |x| [x.values[0], x.keys[0].downcase] } ]
      end
    end

    cds_raw.flatten(1)
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
  end
end