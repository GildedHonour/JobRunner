window.App = {};

window.App = {
    addParamToCurrentUrl: function(newParam) {
        var searchParams = $.extend($.url().param(), newParam);
        var url = $.url().attr('path') + "?" + $.param(searchParams);
        return url.replace(/\?$/, "");
    }
};

// Site wide menu toggle
jQuery(function($) {
    'use strict';
    $(".family.menu").height( $("#main").height() );
    $('.family.menu').hover(function () {
        $('.expanded.wrapper').fadeIn();
    });
    $('.family.menu').mouseleave(function () {
        $('.expanded.wrapper').fadeOut();
    });
});