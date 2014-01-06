App.Contacts = {};

App.Contacts.Index = {
  searchField: $('#typeahead-search'),
  affiliationsFilter: $('#affiliations-filter'),

  init: function() {
    this.initializeContactsSearch();
    this.initializeFilters();
  },

  initializeContactsSearch: function() {
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
        url: '/contacts/',
        data: { 'selected_companies': selectedCompanies.join(',') },
        dataType: 'script'
      });
    });
  }
};

$(function(){
  if($('body.contacts.index').length){
    App.Contacts.Index.init();
  }
});