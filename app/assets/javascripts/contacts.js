$(function() {
  var chkUseCompContInfo = $("#use_comp_cont_info");
  var chkContactCompanyId = $("#contact_company_id");

  //todo refactor name
  function disableCheckboxIfNeeded() {
    chkUseCompContInfo.prop("disabled", $("#contact_company_id").val() == "");
  };

  function showError() {
    $("#contact_info_errors_container").html("This company has no addresses, type it in manually.");
  };

  function clearError() {
    $("#contact_info_errors_container").html("");
  };

  disableCheckboxIfNeeded();

  //todo - refactor
  var addressFormFields = [
    $("#contact_addresses_attributes_0_address_line_1"), 
    $("#contact_addresses_attributes_0_address_line_2"), 
    $("#contact_addresses_attributes_0_city"), 
    $("#contact_addresses_attributes_0_zip"), 
    $("#contact_addresses_attributes_0_state")
  ];

  function resetAddressForm() {
    //todo - refactor
    var items = [
      $("#contact_addresses_attributes_0_address_line_1"),
      $("#contact_addresses_attributes_0_address_line_2"), 
      $("#contact_addresses_attributes_0_city"),
      $("#contact_addresses_attributes_0_zip")
    ];

    for (var i in items) {
      items[i].val("");
    }

    $("#contact_addresses_attributes_0_state").val("ak");
    //todo - remove all other address forms if exist
  };

  function disableAddressForm() {
    $("#addresses :input").prop("disabled", true);
    //todo - disable button "Remove"
  };

  function enableAddressForm() {
    //todo - refactor
    var items = [
      $("#contact_addresses_attributes_0_address_line_1"),
      $("#contact_addresses_attributes_0_address_line_2"), 
      $("#contact_addresses_attributes_0_city"),
      $("#contact_addresses_attributes_0_zip")
    ];

    for (var i in items) {
      items[i].prop("disabled", true);
    }
  };

  $(document).on("page:change", function() {
    $(document).on("submit", "body.contacts form#contact_form", function() {
      var errors = [];
      
      if($("#addresses .fields:visible").length == 0) {
        errors.push("address");
      }

      if($("#phone_numbers .fields:visible").length == 0) {
        errors.push("phone number");
      }

      if($("#emails .fields:visible").length == 0) {
        errors.push("email");
      }

      if(errors.length > 0) {
        $("#contact_info_errors_container").html('<div class="alert alert-danger col-sm-3">At least one ' + errors.join(", ") + ' must be present </div>');
        var top_offset = jQuery("#contact_info_errors_container").offset().top;
        jQuery("html, body").animate({ scrollTop: top_offset }, "slow");
        return false;
      }
    });
  });

  $(document).on("click", "#use_comp_cont_info", function() {
    if (this.checked) {
      $.ajax({
        url: getAddressUrl(chkContactCompanyId.val())
      })
      .done(function(data) {
        switch (data.addresses.length) {
          case 0:
            //1 no address
            //todo - red label
            console.log("the number of the addresses is: 0");
            chkUseCompContInfo.prop("disabled", true);
            chkUseCompContInfo.prop("checked", false);
            showError();
            break;
          
          case 1:
            //2 single address
            //fill out
            console.log("the number of the addresses is: 1");
            var address = data.addresses[0];
            $("#contact_addresses_attributes_0_address_line_1").val(address.address_line_1);
            $("#contact_addresses_attributes_0_address_line_2").val(address.address_line_2);
            $("#contact_addresses_attributes_0_city").val(address.city);
            $("#contact_addresses_attributes_0_zip").val(address.zip);
            $("#contact_addresses_attributes_0_state").val(address.state);

            disableAddressForm();
            break;

          default:
            //3 two or more addresses
            console.log("the number of the addresses is: >= 2");
        }
      })
      .fail(function() {
        alert("error");
      });
    } else {
      resetAddressForm();
    }

  });

  $(document).on("change", "#contact_company_id", function() {
    if ((chkUseCompContInfo).is(":checked")) {
      chkUseCompContInfo.prop("checked", false);
    };

    clearError();
    disableCheckboxIfNeeded();
    resetAddressForm();
  });

});