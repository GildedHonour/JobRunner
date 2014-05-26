module SearchFiltersSaver
  extend ActiveSupport::Concern
  PAGE_SIZE = 100

  included do
    before_filter :load_entities
    before_filter :save_filters, only: :index
    before_filter :set_saved_filters_default_page, only: [:index, :show]
  end

  def include_neighbours(source)
    source_arr = source.to_a
    
    # binding.pry

    # check if it is not the last page
    # so we can include the first contact from the next page
    is_last_page = ((source_arr.size / PAGE_SIZE) + 1) == get_saved_filters[:page]
    unless is_last_page
      first_element = Kaminari.paginate_array(source_arr).page(get_saved_filters[:page] + 1).per(1) 
      source_arr += first_element
    end
    
    # check if it is not the first page
    # so we can include the last contact from the previous page
    unless get_saved_filters[:page] == 1
      last_element = Kaminari.paginate_array(source_arr).page(get_saved_filters[:page] - 1).per(PAGE_SIZE)
      source_arr.unshift(last_element[-1])
    end

    source_arr
  end

  def set_saved_filters_new_page!
    @entities_ids = @entities.map(&:id)
    @entity_index = @entities_ids.find_index { |x| x == @entity.id }
    
    # if the element is not found in the filtered result 
    # (which includes 1 element from the previous page and 1 element from the next page) that means 
    # either it doesn't exist at all in db or
    # it is entered manually in the address bar in the browser (so that it's not in the filtered result but does exist in db)
    # thus we don't have to modify current page number in the search filter in the session
    return unless @entity_index

    binding.pry



    # get the page of @entity.id according to its 
    # position (@entity_index) in the result set
    new_page_index = (@entity_index / PAGE_SIZE) + 1  #todo error: @entity_index is never more than PAGE_SIZE because it's within one page
    set_saved_filters_page(new_page_index)
  end

  def apply_filters(source, incl_neighbours: false)
    source_filtered = source
    if get_saved_filters
      source_filtered = apply_filters_concrete(source)
      unless request.format == :csv
        # source_filtered = source_filtered.page(get_saved_filters[:page]).per(PAGE_SIZE) 
        # source_filtered = include_neighbours(source_filtered) if incl_neighbours 


        source_filtered = include_neighbours(source_filtered) if incl_neighbours 
        source_filtered = Kaminari.paginate_array(source_filtered).page(get_saved_filters[:page]).per(PAGE_SIZE) 
      end
    end

    source_filtered
  end

  def get_saved_filters
    session[params_fileter_key]
  end

  def set_saved_filters(value)
    session[params_fileter_key] = value
  end

  def set_saved_filters_page(value)
    session[params_fileter_key][:page] = value
  end

  def set_saved_filters_default_page
    set_saved_filters({}) unless get_saved_filters
    maybe_page = get_saved_filters[:page] 
    set_saved_filters_page(maybe_page || params[:page].to_i || 1)
  end

  def save_filters
    active_filters = filter_items.select{ |filter_param| params[filter_param].present? }
    if active_filters.present?
      set_saved_filters(params.slice(*active_filters))
    else
      set_saved_filters(nil)
    end
  end

  private

  def params_fileter_key
    (@entity_prefix + "_filter_params").to_sym
  end
end