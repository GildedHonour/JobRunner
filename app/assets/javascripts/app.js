window.App = {};

$.webshims.setOptions("basePath", "/webshims/shims/");
$.webshims.polyfill('forms');

$(document).on("page:load", function() {
    $(this).updatePolyfill();
});