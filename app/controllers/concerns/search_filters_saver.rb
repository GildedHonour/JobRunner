module SearchFiltersSaver
  extend ActiveSupport::Concern
  PAGE_SIZE = 100

  included do
    before_filter :load_entities
    before_filter :save_filters, only: :index
    before_filter :set_saved_filters_default_page, only: [:index, :show]
  end

  def set_saved_filters_new_page!
    @entities_ids = @entities_all_pages.map(&:id)
    @entity_index = @entities_ids.find_index { |x| x == @entity.id }
    
    # if the element is not found in the filtered result 
    # that means either it doesn't exist at all in db or
    # it is entered manually in the address bar in the browser (so that it's not in the filtered result but might exist in db)
    # thus we don't have to modify current page number in the search filter in the session
    return nil unless @entity_index

    # get the page of @entity.id according to its 
    # position (@entity_index) in the result set
    new_page_index = (@entity_index / PAGE_SIZE) + 1
    set_saved_filters_page(new_page_index)
  end

  def apply_filters(source)
    source_filtered_all = source

    if get_saved_filters
      source_filtered_all = apply_filters_concrete(source)
      source_filtered_pagenated = 
        if request.format == :csv
          source_filtered_all
        else
          Kaminari.paginate_array(source_filtered_all).page(get_saved_filters[:page]).per(PAGE_SIZE)
        end 
    end

    [source_filtered_pagenated, source_filtered_all]
  end

  def get_saved_filters
    session[params_filter_key]
  end

  def set_saved_filters(value)
    session[params_filter_key] = value
  end

  def set_saved_filters_page(value)
    session[params_filter_key][:page] = value
  end

  def set_saved_filters_default_page
    set_saved_filters({}) unless get_saved_filters
    maybe_page = get_saved_filters[:page] 
    set_saved_filters_page(maybe_page || params[:page].to_i || 1)
  end

  def save_filters
    active_filters = self.class::FILTER_ITEMS.select { |x| params[x].present? }
    if active_filters.present?
      set_saved_filters(params.slice(*active_filters))
    else
      set_saved_filters(nil)
    end
  end

  def params_filter_key
    (self.class::ENTITY_PREFIX + "_filter_params").to_sym
  end
end