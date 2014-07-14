App.addParamToCurrentUrl = function(newParam) {
  var searchParams = $.extend($.url().param(), newParam);
  var url = $.url().attr('path') + "?" + $.param(searchParams);
  return url.replace(/\?$/, "");
};