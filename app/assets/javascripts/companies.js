App.Companies = {};

App.Companies.Index = {
  searchField: $('#typeahead-search'),

  init: function() {
    this.initializeCompaniesSearch();
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
  }
};

$(function(){
  if($('body.companies.index').length){
    App.Companies.Index.init();
  }
});