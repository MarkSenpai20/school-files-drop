$(document).ready(function() {
    $(".col-md-12").hover(function() {
        $(this).removeClass("shadow-pop-tl-reverse").addClass("shadow-pop-tl");
    }, function() {
        const element = $(this);
        element.removeClass("shadow-pop-tl").addClass("shadow-pop-tl-reverse");

        element.one('animationend webkitAnimationEnd oAnimationEnd MSAnimationEnd', function() {
            element.removeClass("shadow-pop-tl-reverse");
        });
    });
});
