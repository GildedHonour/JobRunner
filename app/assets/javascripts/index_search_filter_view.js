App.IndexSearchFilterView = {
    filters: [
        {
            selector: "#affiliations-filter",
            searchKeyName: "ac",
            selectionInputName: "affiliation_filter[company_ids]"
        },
        {
            selector: "#birthdays-filter",
            searchKeyName: "bm",
            selectionInputName: "birthday_filter[month_ids]"
        },
        {
            selector: "#company-types-filter",
            searchKeyName: "ct",
            selectionInputName: "company_type_filter[company_type_ids]"
        },
        {
            selector: "#relationships-filter",
            searchKeyName: "rc",
            selectionInputName: "relationship_filter[company_ids]"
        }
    ],

    bindEvents: function(bodyClass) {
        $.each(this.filters, function(index, filter) {
            $(document).on('change', bodyClass + ' ' + filter.selector, function() {
                var selectedCompanies = $.map($('input[name="' + filter.selectionInputName + '"]:checked'), function(company_input) {
                    return $(company_input).val();
                });

                var filterParam = {};
                filterParam[filter.searchKeyName] = selectedCompanies;
                Turbolinks.visit(App.addParamToCurrentUrl(filterParam));
            });
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