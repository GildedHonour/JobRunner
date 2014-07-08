function ready() {
  var chkUseCompContInfo = $("#chk_use_company_contact_info");
  var mdlChooseAddress = $("#choose_address");
  var addresses = [];
  var addressFormInputs = [
    $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(0)"),
    $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(1)"),
    $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(2)"),
    $("div.col-md-4.fields:visible:eq(0) div.panel-body input:eq(3)")
  ];

  var addressFormDropDown = $("div.col-md-4.fields:visible:eq(0) div.panel-body select:eq(0)");
  var allAdressFormItems = addressFormInputs.concat(addressFormDropDown);
  var addressFormKeys = ["address_line_1", "address_line_2", "city", "zip", "state"];

  function getAddressesContactsUrl(id) {
    return getRawAddressesContactsUrl.replace(":contact_id", id);
  };

  /*Modal dialog - button "ok"*/
  $(document).on("click", "#choose_address_ok", function() {
    var id = parseInt(mdlChooseAddress.find(".modal-body input[type=radio]:checked").val(), 10); 
    $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    mdlChooseAddress.modal("hide");
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i].id == id) {
        for (var j in allAdressFormItems) {
          allAdressFormItems[j].val(addresses[i][addressFormKeys[j]]);
        }

        setAddressFormState(false);
        break;
      }
    }
  });

  /*Modal dialog - button close*/
  $(document).on("click", "#close_modal", function() {
    if (isAddressFormEmpty()) {
      chkUseCompContInfo.prop("checked", false);
    } else {
      $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    }

    mdlChooseAddress.modal("hide");
  });

  function showErrors() {
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
    for (var i in addressFormInputs) {
      addressFormInputs[i].val("");
    }

    addressFormDropDown.val("ak");
    $("#addresses .col-md-4.fields:visible").not(":eq(0)").remove();
  };

  /*Address Form - add address*/
  $(document).on("click", "div.row div.col-md-4 .btn.btn-default.add_nested_fields", function() {
    if (isCompanySelected()) {
      chkUseCompContInfo.prop("disabled", false);
    }
  });

  /*Address Form - remove address*/
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

  function isAddressFormEmpty() {
    for (var i in allAdressFormItems) {
      if (allAdressFormItems[i] !== "") {
        return false;
      }
    }

    return true;
  }

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

  /*Address Form checkbox - use the contact info of the company*/
  $(document).on("click", "#chk_use_company_contact_info", function() {
    if (this.checked) {
      $.ajax({
        url: getAddressesContactsUrl($("#contact_company_id").val())
      })
      .done(function(data) {
        switch (data.addresses.length) {
          case 0:
            chkUseCompContInfo.prop("disabled", true);
            chkUseCompContInfo.prop("checked", false);
            showErrors();
            break;

          case 1:
            for (var i in allAdressFormItems) {
              allAdressFormItems[i].val(data.addresses[0][addressFormKeys[i]]);
            }
            
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

  $(document).on("click", "#clear_all_filters", function() {
    $(".filters.wrapper input[type='checkbox']:checked").prop("checked", false).trigger("change");
  });

  function setChkState() {
    chkUseCompContInfo.prop("disabled", $("#contact_company_id").val() === "");
  };

  setChkState();
};

jQuery(document).ready(ready);
jQuery(document).on("page:load", ready);