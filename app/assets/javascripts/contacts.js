function ready() {
  var chkUseCompContInfo = $("#chk_use_company_contact_info");
  var chkUseCompPhoneNumber = $("#chk_use_company_phone_number");
  
  var mdlgChooseAddress = $("#choose_address");
  var mdlgChoosePhoneNumber = $("#choose_phone_number");
  
  var addresses = [];
  var phoneNumbers = [];
  var selectedPhoneNumbers = [];
  
  /*Address Form Inputs*/  
  var addressFormInputSelectorBase = "div.col-md-4.fields:visible:eq(0) div.panel-body";
  var addressFormInputs = [
    addressFormInputSelectorBase + " input:eq(0)",
    addressFormInputSelectorBase + " input:eq(1)",
    addressFormInputSelectorBase + " input:eq(2)",
    addressFormInputSelectorBase + " input:eq(3)"
  ];
  var addressFormDropDown = addressFormInputSelectorBase + " select:eq(0)";
  var allAdressFormItems = addressFormInputs.concat(addressFormDropDown);
  var addressFormKeys = ["address_line_1", "address_line_2", "city", "zip", "state"];

  /*Phone Form Inputs*/  
  var phoneNumberFormInputSelectorBase = "#phone_numbers div.col-md-4.fields:visible:eq(0) div.panel-body";
  var phoneNumberFormInputs = [
    phoneNumberFormInputSelectorBase + " input:eq(0)",
    phoneNumberFormInputSelectorBase + " input:eq(1)"
  ];
  var phoneNumberFormDropDown = phoneNumberFormInputSelectorBase + " select:eq(0)";
  var allPhoneNumberFormItems = [phoneNumberFormDropDown].concat(phoneNumberFormInputs);
  var phoneNumberFormKeys = ["kind" ,"phone_number", "extension"];

  function getAddressesContactsUrl(id) {
    return getRawAddressesContactsUrl.replace(":contact_id", id);
  };

  /*Modal dialog Choose Address - button "ok"*/
  $(document).on("click", "#choose_address_ok", function() {
    var id = parseInt(mdlgChooseAddress.find(".modal-body input[type='radio']:checked").val(), 10); 
    $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    mdlgChooseAddress.modal("hide");
    for (var i = 0; i < addresses.length; i++) {
      if (addresses[i].id == id) {
        for (var j in allAdressFormItems) {
          $(allAdressFormItems[j]).val(addresses[i][addressFormKeys[j]]);
        }

        setAddressFormState(false);
        break;
      }
    }
  });

  /*Modal dialog choose address - button close*/
  $(document).on("click", "#choose_address_close", function() {
    if (isAddressFormEmpty()) {
      chkUseCompContInfo.prop("checked", false);
    } else {
      $("#contact_info_container").html("This company also has <a href='#'>other addresses</a>.");
    }

    mdlgChooseAddress.modal("hide");
  });

  function showAddressFormErrors() {
    $("#contact_info_errors_container").html("This company doesn't have an address.");
  };

  function clearAddressFormErrors() {
    $("#contact_info_errors_container").html("");
    $("#contact_info_container").html("");
  };

  function doesAddressFormExist() {
    return $("#addresses div.col-md-4.fields:visible").length > 0;
  };

  function doesPhoneNumberFormExist() {
    return $("#phone_numbers div.col-md-4.fields:visible").length > 0;
  };
  

  function resetAddressForm() {
    for (var i in addressFormInputs) {
      $(addressFormInputs[i]).val("");
    }

    $(addressFormDropDown).val("ak");
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

    if ((chkUseCompPhoneNumber).is(":checked")) {
      chkUseCompPhoneNumber.prop("checked", false);
    }

    if (isCompanySelected()) {
      if (doesAddressFormExist()) {
        chkUseCompContInfo.prop("disabled", false);  
      }

      if (doesPhoneNumberFormExist()) {
        chkUseCompPhoneNumber.prop("disabled", false);  
      }
    } else {
      chkUseCompContInfo.prop("disabled", true);
      chkUseCompContInfo.prop("checked", false);

      chkUseCompPhoneNumber.prop("disabled", true);
      chkUseCompPhoneNumber.prop("checked", false);
    }

    resetAddressForm();
    setAddressFormState(true);
    clearAddressFormErrors();

    resetPhoneNumberForm();
    setPhoneNumberFormState(true);
    clearPhoneNumberErrors();
  });

  function isCompanySelected() {
    return $("#contact_company_id").val() !== "";
  };

  /* Address Form - set enabled / disabled state
  true - enabled, false - disabled */
  function setAddressFormState(isEnabled) {
    for (var i in allAdressFormItems) {
      $(allAdressFormItems[i]).prop("disabled", !isEnabled);
    }
  };

  function isAddressFormEmpty() {
    for (var i in allAdressFormItems) {
      if ($(allAdressFormItems[i]) !== "") {
        return false;
      }
    }

    return true;
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
            showAddressFormErrors();
            break;

          case 1:
            for (var i in allAdressFormItems) {
              $(allAdressFormItems[i]).val(data.addresses[0][addressFormKeys[i]]);
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
            mdlgChooseAddress.find(".modal-body").html(str);
            mdlgChooseAddress.modal("show");
        }
      })
      .fail(function() {
        chkUseCompContInfo.prop("checked", false);
        alert("Something went wrong, try again.");
      });
    } else {
      resetAddressForm();
      clearAddressFormErrors();
      setAddressFormState(true);
    }
  });
  
  $("#contact_info_container").on("click", "a", function(e) {
    e.preventDefault();
    mdlgChooseAddress.modal("show");
  });

  /*Contact form - on submit*/
  $("#contact_form").on("submit", function(e) {
    for (var j in allAdressFormItems) {
      var elem1 = $(allAdressFormItems[j]);
      $("<input>").attr({type: "hidden", name: elem1.attr("name"), value: elem1.val()}).appendTo($(this));
    }

    for (var i = 0; i < disabledPhoneFormsCount(); i++) { 
      for (var j in allPhoneNumberFormItems) {
        var elem2 = $(allPhoneNumberFormItems[j].replace("visible:eq(0)", "visible:eq(" + i + ")"));
        $("<input>").attr({type: "hidden", name: elem2.attr("name"), value: elem2.val()}).appendTo($(this));
      }
    }
  });

  function disabledPhoneFormsCount() {
    var res = 0;
    $("#phone_numbers div.col-md-4.fields").each(function(index, value) {
      var selectorBase = "div.panel.panel-default div.panel-body"; 
      if ($(value).find(selectorBase + " select:disabled").length &&
          $(value).find(selectorBase + " div.row input:disabled:eq(0)").length &&
          $(value).find(selectorBase + " div.row input:disabled:eq(1)").length) {
        res++;
      }
    });

    return res;
  };

  /*Filters - clear all*/
  $(document).on("click", "#clear_all_filters", function() {
    $(".filters.wrapper input[type='checkbox']:checked").prop("checked", false).trigger("change");
  });

  /*Checkboxes Use the contact info and Phone Numbers of the company*/
  (function() {
    var st = $("#contact_company_id").val() === "";
    chkUseCompContInfo.prop("disabled", st);
    chkUseCompPhoneNumber.prop("disabled", st);
  })();

  /*******************************************************************************************************/
  function getPhoneNumbersContactsUrl(id) {
    return getRawPhoneNumbersContactsUrl.replace(":contact_id", id);
  };

  /*Phone Form checkbox - use the phones of the company*/
  $(document).on("click", "#chk_use_company_phone_number", function() {
    
    resetPhoneNumberForm();
    // clearPhoneNumberErrors();
    // setPhoneNumberFormState(true); todo?

    if (this.checked) {
      $.ajax({
        url: getPhoneNumbersContactsUrl($("#contact_company_id").val())
      })
      .done(function(data) {
        switch (data.phone_numbers.length) {
          case 0:
            chkUseCompPhoneNumber.prop("disabled", true);
            chkUseCompPhoneNumber.prop("checked", false);
            showUseCompPhoneNumberErrors();
            break;

          case 1:
            for (var i in allPhoneNumberFormItems) {
              $(allPhoneNumberFormItems[i]).val(data.phone_numbers[0][phoneNumberFormKeys[i]]);
              $(allPhoneNumberFormItems[i]).prop("disabled", true);
            }

            //todo - hack 
            // remove?
            phoneNumbers.push(data.phone_numbers[0]); 
            // todo
            // setPhoneNumberFormState(false);


            break;

          default:
            //todo - copy instead of =
            phoneNumbers = data.phone_numbers;
            
            var str = "<form action='#'>";
            for (var i in data.phone_numbers) {
              str += "<input type='checkbox' ";
              str += "value='" + data.phone_numbers[i].id + "' ";
              str += "name='phone_numbers' style='margin-left: 5px;' />";
              str += "<label style='font-size: 16px; font-weight: normal; margin-left: 10px;'>";
              str += data.phone_numbers[i].str;
              str += "</label>";
              str += "<br />";
            }

            str += "</form>";
            mdlgChoosePhoneNumber.find(".modal-body").html(str);
            mdlgChoosePhoneNumber.modal("show");
        }
      })
      .fail(function() {
        chkUseCompPhoneNumber.prop("checked", false);
        alert("Something went wrong, try again.");
      });
    } else {
      resetPhoneNumberForm();
      clearPhoneNumberErrors();
      setPhoneNumberFormState(true);
    }
  });
  
  //todo
  /*Modal dialog Choose Address - button "ok"*/
  $(document).on("click", "#choose_phone_number_ok", function() {

    resetPhoneNumberForm();
    // setPhoneNumberFormState(true); //todo - remove?
    // clearPhoneNumberErrors(); //todo - remove?

    selectedPhoneNumbers = getSelectedPhoneNumbers();

    addRemainingPhoneNumberForms();
    setPhoneNumberFormsValues();
    mdlgChoosePhoneNumber.modal("hide");
    // if (phoneNumbers.length > 1) { /* todo - it is already always > 1 */
      $("#phone_number_container").html("This company also has <a href='#'>other phone numbers</a>.");
    // }
  });

  /*Modal dialog choose Phone number - button close*/
  $(document).on("click", "#choose_phone_number_close", function() {
    if (isPhoneNumberFormEmpty()) {
      chkUseCompPhoneNumber.prop("checked", false);
    } else if (isAnyPhoneNumberChecked()) {
      $("#phone_number_container").html("This company also has <a href='#'>other phone numbers</a>.");
    }

    mdlgChoosePhoneNumber.modal("hide");
  });

  function isPhoneNumberFormEmpty() {
    return $(phoneNumberFormInputs[0]).val() === "" && $(phoneNumberFormDropDown).val() === "business";
  };

  $("#phone_number_container").on("click", "a", function(e) {
    e.preventDefault();
    mdlgChoosePhoneNumber.modal("show");
  });

  /* check / uncheck checkboxes in modal dialog for choosing phone number*/
  $(document).on("click", "#choose_phone_number input[type='checkbox']", function() {
    var btn = $("#choose_phone_number button.btn.btn-primary");
    btn.prop("disabled", !isAnyPhoneNumberChecked());
  });

  function isAnyPhoneNumberChecked() {
    return $("#choose_phone_number input:checked").length;
  };

  function showUseCompPhoneNumberErrors() {
    $("#phone_number_errors_container").html("This company doesn't have a phone number.");
  };

  /* Phone Number Form - set enabled / disabled state
    true - enabled, false - disabled */
  function setPhoneNumberFormState(isEnabled) {
    for (var i = 0; i < phoneNumbers.length; i++) { 
      for (var j in allPhoneNumberFormItems) {
        var elem = allPhoneNumberFormItems[j].replace("visible:eq(0)", "visible:eq(" + i + ")");
        $(elem).prop("disabled", !isEnabled);
      }
    }
  };

  function resetPhoneNumberForm() {
    for (var i in phoneNumberFormInputs) {
      $(phoneNumberFormInputs[i]).val("");
    }

    $(phoneNumberFormDropDown).val("business");
    $("#phone_numbers .col-md-4.fields:visible").not(":eq(0)").remove();
  };

  function clearPhoneNumberErrors() {
    $("#phone_number_container").html("");
    $("#phone_number_errors_container").html("");
  };

  function addRemainingPhoneNumberForms() {
    for (var i = 0; i < selectedPhoneNumbers.length - 1; i++) {
      $(".add-new-phone-number-form").trigger("click");
    }
  };

  function setPhoneNumberFormsValues() {
    for (var i = 0; i < selectedPhoneNumbers.length; i++) {
      for (var j in allPhoneNumberFormItems) {
        var elem = allPhoneNumberFormItems[j].replace("visible:eq(0)", "visible:eq(" + i + ")");
        $(elem).val(selectedPhoneNumbers[i][phoneNumberFormKeys[j]]);
        $(elem).prop("disabled", true);
      }
    }
  };

  function getSelectedPhoneNumbers() {
    var res = [];
    var idsRaw = mdlgChoosePhoneNumber.find(".modal-body input[type='checkbox']:checked");
    for (var i = 0; i < idsRaw.length; i++) {
      var id = parseInt(idsRaw[i].value, 10);
      // ids.push(id); //todo - remove?
      for (var j in phoneNumbers) { 
        if (phoneNumbers[j].id === id) {
          res.push(phoneNumbers[j]);
          break;
        }  
      }    
    }

    return res.slice();
  };

};

jQuery(document).ready(ready);
jQuery(document).on("page:load", ready);