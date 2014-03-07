$(document).on('nested:fieldRemoved', function (event) {
    $('[required]', event.field).removeAttr('required');
});
