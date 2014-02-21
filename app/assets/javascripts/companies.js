App.Companies = {};

App.Companies.Index = {
    bindEvents: function() {
        $(document).on('change', 'body.companies.index #affiliations-filter', function() {
            var selectedCompanies = $.map($('input[name="affiliation_filter[company_ids]"]:checked'), function(principal_input) {
                return $(principal_input).val();
            });

            Turbolinks.visit(App.addParamToCurrentUrl({ c: selectedCompanies }));
        })
    },

    initPlugins: function() {
        $("#typeahead-search").typeWatch({
            wait: 1500,
            captureLength: 0,
            highlight: true,
            callback: function(term) {
                Turbolinks.visit(App.addParamToCurrentUrl({ search: term }));
            }
        });
        $('#typeahead-search').focus().val($('#typeahead-search').val());
    }
};

$(document).on('page:change', function() {
    if($('body.companies.index').length) {
        App.Companies.Index.initPlugins();
    }
});

$(function() {
    App.Companies.Index.bindEvents();
});