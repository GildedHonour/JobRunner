module ContactsHelper
  def tooltip_text_for_filter(filter)
    {
      relationships: "Shows all contacts of a company where the company is related to the selected internal company",
      roles: "Shows all contacts of a company where the company is related to an internal company in the selected role",
      status: "Shows all contacts of a company where the company has the selected affiliation or relationship status",
      company_type: "Shows all contacts of a company where the company is of the selected type",
      birthday: "Shows contacts with the selected birthday"
    }[filter]
  end

  # todo refactoring, move to BackForwardNavigator
  def get_next_prev_entity_link(is_forward, title, &content_tag)
    arrow = is_forward ? "right" : "left"
    span_tag = content_tag(:span, nil, class: "glyphicon glyphicon-chevron-#{arrow}")
    m_np_id = maybe_next_prev_entity_id(is_forward)
    return span_tag unless m_np_id
    link_to(contact_path(m_np_id), title: title) { span_tag }
  end

  private

  # todo refactoring, move to BackForwardNavigator
  def maybe_next_prev_entity_id(is_forward) 
    return nil unless @entity_index
    if is_forward
      @entity_index != @entities_ids.size - 1 ? @entities_ids[@entity_index + 1] : nil
    else
      @entity_index != 0 ? @entities_ids[@entity_index - 1] : nil
    end
  end
end