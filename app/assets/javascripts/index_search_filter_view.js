App.IndexSearchFilterView = {
    bindEvents: function(bodyClass) {
        $(document).on('change', bodyClass + ' #affiliations-filter', function() {
            var selectedCompanies = $.map($('input[name="affiliation_filter[company_ids]"]:checked'), function(company_input) {
                return $(company_input).val();
            });

            Turbolinks.visit(App.addParamToCurrentUrl({ ac: selectedCompanies }));
        });

        $(document).on('change', bodyClass + ' #relationships-filter', function() {
            var selectedCompanies = $.map($('input[name="relationship_filter[company_ids]"]:checked'), function(company_input) {
                return $(company_input).val();
            });

            Turbolinks.visit(App.addParamToCurrentUrl({ rc: selectedCompanies }));
        });
    },

    initPlugins: function(bodyClass) {
        if($(bodyClass).length) {
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
    }
}

$(function() {
    App.IndexSearchFilterView.bindEvents("body.contacts.index");
    App.IndexSearchFilterView.bindEvents("body.companies.index");
});

$(document).on('page:change', function() {
    App.IndexSearchFilterView.initPlugins("body.contacts.index");
    App.IndexSearchFilterView.initPlugins("body.companies.index");
});