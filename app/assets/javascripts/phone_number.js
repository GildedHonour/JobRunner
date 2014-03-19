$(document).on('page:change nested:fieldAdded', function() {
    $('input[data=phone-number-input]').mask('(999) 999-9999');
    $('input[data=phone-number-extension-input]').mask('x 9?9999');
});