function ready() {
  var chkUseCompContInfo = $("#chk_use_company_contact_info");
  var mdlChooseAddress = $("#choose_address");
  var addresses = [];

  /*Modal dialog - button "ok"*/
  $(document).on("click", "#btn_choose_address", function() {
    var id = parseInt(mdlChooseAddress.find(".modal-body input[type=radio]:checked").val(), 10); 
    $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    mdlChooseAddress.modal("hide");
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i].id == id) {
        $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(0)").val(addresses[i].address_line_1)
        $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(1)").val(addresses[i].address_line_2)
        $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(2)").val(addresses[i].city)
        $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(3)").val(addresses[i].zip)
        $("div.col-md-4.fields:visible:eq(0) div.panel-body select:eq(0)").val(addresses[i].state)
        setAddressFormState(false);
        break;
      }
    }
  });

  /*Modal dialog - close*/
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

    mdlChooseAddress.modal("hide");
  });

  function showErrors() {
    //todo append
    $("#contact_info_errors_container").html("This company doesn't have an address.");
  };

  function clearErrors() {
    $("#contact_info_errors_container").html("");
    $("#contact_info_container").html("");
  };

  function doesAddressFormExist() {
    return $("div.col-md-4.fields:visible").length > 1;
  };

  function resetAddressForm() {
    //todo - refactor
    var items = [
      $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(0)"),
      $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(1)"),
      $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(2)"),
      $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(3)")
    ];

    for (var i in items) {
      items[i].val("");
    }

    $("div.col-md-4.fields:visible:eq(0) div.panel-body select:eq(0)").val("ak");
    $("#addresses .col-md-4.fields:visible").not(":eq(0)").remove();
  };

  

  /*Address From - add address*/
  $(document).on("click", "div.row div.col-md-4 .btn.btn-default.add_nested_fields", function() {
    if (isCompanySelected()) {
      chkUseCompContInfo.prop("disabled", false);
    }
  });

  /*Address From - remove address*/
  $(document).on("click", "#addresses .btn.btn-danger.remove_nested_fields:visible:eq(0)", function() {
    if (!doesAddressFormExist()) {
      chkUseCompContInfo.prop("disabled", true);
      chkUseCompContInfo.prop("checked", false);
    }
  });

  /*Drop Down - select company*/
  $(document).on("change", "#contact_company_id", function() {
    if ((chkUseCompContInfo).is(":checked")) {
      chkUseCompContInfo.prop("checked", false);
    }

    if (isCompanySelected() && doesAddressFormExist()) {
      chkUseCompContInfo.prop("disabled", false);
    } else {
      chkUseCompContInfo.prop("disabled", true);
      chkUseCompContInfo.prop("checked", false);
    }

    resetAddressForm();
    setAddressFormState(true);
    clearErrors();
  });

  function isCompanySelected() {
    return $("#contact_company_id").val() !== "";
  }

  /* Address Form - set enabled / disabled state
  true - enabled, false - disabled */
  function setAddressFormState(isEnabled) {
    $("#addresses :input").prop("disabled", !isEnabled);
    $("#addresses select").prop("disabled", !isEnabled);
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
            chkUseCompContInfo.prop("disabled", true);
            chkUseCompContInfo.prop("checked", false);
            showErrors();
            break;

          case 1:
            var address = data.addresses[0];
            $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(0)").val(address.address_line_1);
            $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(1)").val(address.address_line_2);
            $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(2)").val(address.city);
            $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(3)").val(address.zip);
            $("div.col-md-4.fields:visible:eq(0) div.panel-body select:eq(0)").val(address.state);
            setAddressFormState(false);
            break;

          default:
            var adr = data.addresses;
            addresses = adr;
            var str = "<form action='#'>";
            for (var i in adr) {
              str += "<input type='radio' ";
              str += "value='" + adr[i].id + "' ";
              if (i == 0) {
                str += "checked='checked' ";
              }

              str += "name='addresses' style='margin-left: 5px;'/>";
              str += "<label style='font-size: 16px; font-weight: normal; margin-left: 10px;'>";
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
            mdlChooseAddress.find(".modal-body").html(str);
            mdlChooseAddress.modal("show");
        }
      })
      .fail(function() {
        chkUseCompContInfo.prop("checked", false);
        alert("Something went wrong, try again.");
      });
    } else {
      resetAddressForm();
      clearErrors();
      setAddressFormState(true);
    }
  });
  
  $("#contact_info_container").on("click", "a", function(e) {
    e.preventDefault();
    mdlChooseAddress.modal("show");
  });

  function setChkState() {
    chkUseCompContInfo.prop("disabled", $("#contact_company_id").val() === "");
  };

  setChkState();
};

jQuery(document).ready(ready);
jQuery(document).on("page:load", ready);