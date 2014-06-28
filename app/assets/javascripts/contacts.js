function ready() {
  var chkUseCompContInfo = $("#use_comp_cont_info");
  // var contactCompanyId = $("#contact_company_id");
  var modal = $("#myModal");
  var addresses = [];

  $(document).on("click", "#btn_choose_address", function() {
    var id = parseInt(modal.find(".modal-body input[type=radio]:checked").val(), 10); 
    $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    modal.modal("hide");
    
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i].id == id) {
        $("#contact_addresses_attributes_0_address_line_1").val(addresses[i].address_line_1);
        $("#contact_addresses_attributes_0_address_line_2").val(addresses[i].address_line_2);
        $("#contact_addresses_attributes_0_city").val(addresses[i].city);
        $("#contact_addresses_attributes_0_zip").val(addresses[i].zip);
        $("#contact_addresses_attributes_0_state").val(addresses[i].state);
        disableAddressForm();
        break;
      }
    }
  });

  $(document).on("click", "#close_modal", function() {
    if (
      $("#contact_addresses_attributes_0_address_line_1").val() === "" &&
      $("#contact_addresses_attributes_0_address_line_2").val() === "" &&
      $("#contact_addresses_attributes_0_city").val() === "" &&
      $("#contact_addresses_attributes_0_zip").val() === "" 
    ) {
      chkUseCompContInfo.prop("checked", false);
    } else {
      $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    }

    modal.modal("hide");
  });

  //todo refactor name
  function disableCheckboxIfNeeded() {
    chkUseCompContInfo.prop("disabled", $("#contact_company_id").val() === "");
  };

  function showError() {
    $("#contact_info_errors_container").html("This company doesn't have an address.");
  };

  function clearError() {
    $("#contact_info_errors_container").html("");
    $("#contact_info_container").html("");
  };

  disableCheckboxIfNeeded();

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
    $("#addresses .col-md-4.fields").not(":eq(0)").remove();
  };

  function disableAddressForm() {
    $("#addresses :input").prop("disabled", true);
    $("#addresses .btn.btn-danger.remove_nested_fields").attr("disabled", true);
  };

  function enableAddressForm() {
    $("#addresses :input").prop("disabled", false);
    $("#addresses .btn.btn-danger.remove_nested_fields").attr("disabled", false);
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
        url: getAddressUrl($("#contact_company_id").val())
      })
      .done(function(data) {
        switch (data.addresses.length) {
          case 0:
            //1 no address
            //todo - red label
            chkUseCompContInfo.prop("disabled", true);
            chkUseCompContInfo.prop("checked", false);
            showError();
            break;
          
          case 1:
            //2 single address
            //fill out
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
            var adr = data.addresses;
            addresses = adr;
            var str = "<form action='#'>";
            for (var i in adr) {
              str += "<input type='radio' ";
              str += "value='" + adr[i].id + "' ";
              if (i == 0) {
                str += "checked='checked' ";
              }
              str += "name='addresses' />";

              str += "<label style='font-size: 16px; font-weight: normal'>";
              str += adr[i].address_line_1 + ", ";
              if (adr[i].address_line_2 !== undefined) {
                str += " " + adr[i].address_line_2 + ", ";
              }
              
              str += " " + adr[i].city + ", ";
              str += " " + adr[i].zip + ", ";
              str += " " + adr[i].state.toUpperCase() + ", ";
              str += " " + adr[i].country.toUpperCase();
              str += "</label>";
              str += "<br />";
            }

            str += "</form>";
            $("#myModal .modal-body").html(str);
            $("#myModal").modal("show");
        }
      })
      .fail(function() {
        chkUseCompContInfo.prop("checked", false);
        alert("Something went wrong, try again.");
      });
    } else {
      resetAddressForm();
      clearError();
      enableAddressForm();
    }
  });
  
  $("#contact_info_container").on("click", "a", function(e) {
    e.preventDefault();
    $("#myModal").modal("show");
  });

  $(document).on("change", "#contact_company_id", function() {
    if ((chkUseCompContInfo).is(":checked")) {
      chkUseCompContInfo.prop("checked", false);
    };

    clearError();
    disableCheckboxIfNeeded();
    resetAddressForm();
    enableAddressForm();
  });
};

jQuery(document).ready(ready);
jQuery(document).on("page:load", ready);