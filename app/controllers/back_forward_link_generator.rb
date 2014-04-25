module BackForwardLinkGenerator
  def link_to_next_entity(title)
    link_to_previous_entity_impl(true, title)
  end

  def link_to_previous_entity(title)
    link_to_previous_entity_impl(false, title)
  end

  private

  def link_to_previous_entity_impl(is_forward, title)
    arrow = is_forward ? "right" : "left"
    span_tag = content_tag(:span, nil, class: "glyphicon glyphicon-chevron-#{arrow}")
    m_np_id = maybe_next_prev_entity_id(is_forward)
    return span_tag unless m_np_id
    link_to(entity_path.call(m_np_id), title: title) { span_tag }
  end

  def maybe_next_prev_entity_id(is_forward) 
    return nil unless @entity_index
    if is_forward
      @entity_index != @entities_ids.size - 1 ? @entities_ids[@entity_index + 1] : nil
    else
      @entity_index != 0 ? @entities_ids[@entity_index - 1] : nil
    end
  end
end