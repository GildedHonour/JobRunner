$(document).on('page:change', function() {
    $(document).on('submit', 'body.contacts form#contact_form', function() {
        var errors = [];
        if($('#addresses .fields:visible').length == 0) {
            errors.push("address");
        }
        if($('#phone_numbers .fields:visible').length == 0) {
            errors.push("phone number");
        }
        if($('#emails .fields:visible').length == 0) {
            errors.push("email");
        }
        if(errors.length > 0) {
            $("#contact_info_errors_container").html('<div class="alert alert-danger col-sm-3">Atleast one ' + errors.join(", ") + ' must be present </div>');
            var top_offset = jQuery('#contact_info_errors_container').offset().top;
            jQuery('html, body').animate({ scrollTop: top_offset }, 'slow');

            return false
        }
    });
});
