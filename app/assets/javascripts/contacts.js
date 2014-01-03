App.Contacts = {};

App.Contacts.Index = {
  searchField: $('#typeahead-search'),

  init: function() {
    this.initializeContactsSearch();
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
  }
};

$(function(){
  if($('body.contacts.index').length){
    App.Contacts.Index.init();
  }
});