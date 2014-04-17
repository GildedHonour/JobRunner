class ContactsController < ApplicationController
  respond_to :html, :js, :csv, :vcf

  PAGE_SIZE = 100

  before_filter :load_contacts
  before_filter :save_filters, only: :index
  before_filter :set_saved_filters_default_page, only: [:index, :show]


  def new
    @contact = @contacts.build
    respond_with @contact
  end

  def create
    @contact = @contacts.build(contact_params)
    if @contact.save
      redirect_to save_success_url
    else
      render :new
    end
  end

  def edit
    render :new
  end

  def update
    if @contact.update_attributes(contact_params)
      redirect_to save_success_url
    else
      render :new
    end
  end

  def index
    @contacts = apply_filters(@contacts)
    respond_with(@contacts)
  end

  def show
    @contacts = apply_filters(@contacts, incl_neighbours: true)
    @contacts_ids = @contacts.map(&:id)
    set_saved_filters_new_page!
    
    respond_with do |format|
      format.html { respond_with @contact }
      format.vcf do 
        send_data(@contact.to_vcf, filename: "#{@contact.full_name}.vcf", "Content-Disposition" => "attachment",
                  "Content-type" => "text/x-vcard; charset=utf-8"
        )
      end
    end
  end

  def destroy
    @contact.destroy
    redirect_to destroy_success_url
  end

  def edit_section
    @section = params[:section]
    respond_to do |format|
      format.js { render("edit_section") }
    end
  end

  def update_section
    @section = params[:section]
    if @contact.update_attributes(contact_params)
      render :success
    else
      render :edit_section
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :middle_name, :last_name, :prefix, :job_title, :company_id, :birthday,
                                    :contest_participant, :send_mmi_ballgame_emails, :do_not_mail, :do_not_email, :send_cookies, contact_source_ids: [],
                                    addresses_attributes: [:id, :address_line_1, :address_line_2, :city, :state, :zip, :country, :_destroy],
                                    emails_attributes: [:id, :value, :_destroy],
                                    phone_numbers_attributes: [:id, :extension, :kind, :phone_number, :_destroy]
    )
  end

  def destroy_success_url
    @company ? company_url(@company) : contacts_url_with_saved_filters
  end

  def load_contacts
    @company = Company.find(params[:company_id]) if params[:company_id].present?
    @contacts = @company ? @company.contacts : Contact.all
    @contact = @contacts.find(params[:id]) if params[:id].present?
  end

  def save_filters
    active_filters = %i(a bm ct irr rc search name_sort).select{ |filter_param| params[filter_param].present? }
    if active_filters.present?
      set_saved_filters(params.slice(*active_filters))
    else
      set_saved_filters(nil)
    end
  end

  def get_saved_filters
    session[:contact_filter_params]
  end

  def set_saved_filters(value)
    session[:contact_filter_params] = value
  end

  def set_saved_filters_page(value)
    session[:contact_filter_params][:page] = value
  end

  def set_saved_filters_default_page
    maybe_page = get_saved_filters[:page]
    set_saved_filters_page(maybe_page || 1)
  end

  def save_success_url
    @company ? company_url(@company) : contact_url(@contact)
  end

  def apply_filters(source, incl_neighbours: false)
    source_filtered = source
    if get_saved_filters
      source_filtered = get_saved_filters.has_key?(:search) ? source.search(get_saved_filters[:search]) : source
      source_filtered = source_filtered.with_archived_status(get_saved_filters[:a]) if get_saved_filters.has_key?(:a)
      source_filtered = source_filtered.with_birthday_months(get_saved_filters[:bm]) if get_saved_filters.has_key?(:bm)
      
      source_filtered = source_filtered.contacts_of_companies_with_company_types(get_saved_filters[:ct]) if get_saved_filters.has_key?(:ct)
      source_filtered = source_filtered.contacts_of_companies_with_internal_relationship_role(get_saved_filters[:irr]) if get_saved_filters.has_key?(:irr)
      source_filtered = source_filtered.contacts_of_companies_with_relationship_to(get_saved_filters[:rc]) if get_saved_filters.has_key?(:rc)

      source_filtered = get_saved_filters[:name_sort] == "down" ? source_filtered.order("first_name DESC") : source_filtered.order("first_name ASC")
      
      unless request.format == :csv
        source_filtered = source_filtered.page(get_saved_filters[:page]).per(PAGE_SIZE) 
        source_filtered = include_neighbours(source_filtered) if incl_neighbours 
      end
    end

    source_filtered
  end

  def set_saved_filters_new_page!
    @contact_index = @contacts_ids.find_index { |x| x == @contact.id }
    
    # if the element is not found in the filtered result 
    # (which includes 1 element from the previous page and 1 element from the next page) that means 
    # either it doesn't exist at all in db or
    # it is entered manually in the address bar in the browser (so that it's not in the filtered result but does exist in db)
    # thus we don't have to modify current page number in the search filter in the session
    return unless @contact_index

    # get the page of @contact.id according to its 
    # position (@contact_index) in the result set
    new_page_index = (@contact_index / PAGE_SIZE) + 1 
    set_saved_filters_page(new_page_index)
  end

  def include_neighbours(source)
    source_arr = source.to_a
    
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
      source_arr.unshift(res[-1])
    end

    source_arr
  end
end