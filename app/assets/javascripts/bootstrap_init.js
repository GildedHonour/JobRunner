$(document).on('page:before-change', function() {
    $('[data-toggle=tooltip]').tooltip('destroy');
});
$(document).on('page:change', function() {
    $('[data-toggle=tooltip]').tooltip();
});