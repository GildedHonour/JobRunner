window.App = {};

// Setting up x-editable
$.fn.editable.defaults.mode = 'inline';
$.fn.editable.defaults.ajaxOptions = {type: "PATCH"};

$(document).ready(function() {
    $('span#first_name').editable({
    	params: function(params) {
    		var data = {};
    		data = {'contact': {'id': params.pk, 'first_name':params.value}};
    		return data;
    	}
    });
    $('span#last_name').editable({
    	params: function(params) {
    		var data = {};
    		data = {'contact': {'id': params.pk, 'last_name':params.value}};
    		return data;
    	}
    });
});