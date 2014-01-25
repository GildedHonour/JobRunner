window.App = {};

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