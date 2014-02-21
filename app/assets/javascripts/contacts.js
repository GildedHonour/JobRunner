App.Contacts = {};

App.Contacts.Index = {
    bindEvents: function() {
        $(document).on('change', 'body.contacts.index #affiliations-filter', function() {
            var selectedContacts = $.map($('input[name="affiliation_filter[company_ids]"]:checked'), function(principal_input) {
                return $(principal_input).val();
            });

            Turbolinks.visit(App.addParamToCurrentUrl({ c: selectedContacts }));
        })
    },

    initPlugins: function() {
        $("#typeahead-search").typeWatch({
            wait: 1500,
            captureLength: 0,
            highlight: true,
            callback: function(value) {
                Turbolinks.visit(App.addParamToCurrentUrl({ search: value }));
            }
        });
        $('#typeahead-search').focus().val($('#typeahead-search').val());
    }
};

$(document).on('page:change', function() {
    if($('body.contacts.index').length) {
        App.Contacts.Index.initPlugins();
    }
});

$(function() {
    App.Contacts.Index.bindEvents();
});