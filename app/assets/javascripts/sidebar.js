$(document).on('page:change', function() {
    $(".family.menu").height( $("#main").height() );
    $('.family.menu').hover(function () {
        $('.expanded.wrapper').fadeIn();
    });
    $('.family.menu').mouseleave(function () {
        $('.expanded.wrapper').fadeOut();
    });
});
