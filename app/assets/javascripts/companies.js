App.Companies = {};

App.Companies.Index = {
  searchField: $('#typeahead-search'),
  affiliationsFilter: $('#affiliations-filter'),

  init: function() {
    this.initializeCompaniesSearch();
    this.initializeFilters();
  },

  initializeCompaniesSearch: function() {
    this.searchField.typeWatch({
      wait: 750,
      captureLength: 0,
      highlight: true,
      callback: function (value) {
        $.ajax({
          url: $(this).data('search-url'),
          data: { search: value },
          dataType: 'script'
        });
      }
    })
  },

  initializeFilters: function() {
    this.affiliationsFilter.on('change', function() {
      var selectedCompanies = $.map($('input[name="affiliation_filter[company_ids]"]:checked'), function(principal_input) {
        return $(principal_input).val();
      });

      $.ajax({
        method: 'GET',
        url: '/companies/',
        data: { 'selected_companies': selectedCompanies.join(',') },
        dataType: 'script'
      });
    });
  }
};

$(function(){
  if($('body.companies.index').length){
    App.Companies.Index.init();
  }
});