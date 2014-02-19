App.Contacts = {};

App.Contacts.Index = {
  init: function() {
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
    $(document).on('change', 'body.contacts.index #affiliations-filter, body.companies.index #affiliations-filter', function() {
        var selectedCompanies = $.map($('input[name="affiliation_filter[company_ids]"]:checked'), function(principal_input) {
            return $(principal_input).val();
        });

        var searchParams = $.extend($.url().param(), { c: selectedCompanies });
        var url = $.url().attr('path') + "?" + $.param(searchParams);
        Turbolinks.visit(url.replace(/\?$/, ""));
    })
  }
};

$(function(){
    App.Contacts.Index.init();
});