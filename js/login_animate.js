/**
 * Created by duocai on 2017/6/11.
 */

$(function() {
    $(".btn").click(function() {
        var left = ($(window).width() * (1 - 0.35)) / 2; //box弹出框距离左边的额距离
        var height = ($(window).height() * (1 - 0.5)) / 2;
        $(".box").addClass("animated bounceIn").show().css({
            left: left,
            top: top
        });
        $(".opacity_bg").css("opacity", "0.3").show();
    });


    $(".close").click(function() {

        var left = ($(window).width() * (1 - 0.35)) / 2;
        var top = ($(window).height() * (1 - 0.5)) / 2;
        $(".box").show().animate({
            width: "-$(window).width()*0.35",
            height: "-$(window).height()*0.5",
            left: "-" + left + "px",
            top: "-" + top + "px"
        }, 1000, function() {
            var width1 = $(window).width() * 0.35;
            var height1 = $(window).height() * 0.5;
            console.log(width1);
            $(this).css({
                width: width1,
                height: height1
            }).hide();
        });

    });
});