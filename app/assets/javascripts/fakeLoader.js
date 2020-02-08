/*--------------------------------------------------------------------
 *JAVASCRIPT "FakeLoader.js"
 *Version:    1.1.0 - 2014
 *author:     João Pereira
 *website:    http://www.joaopereira.pt
 *Licensed MIT
-----------------------------------------------------------------------*/
(function ($) {

    $.fn.fakeLoader = function(options,callback,data) {
        //Defaults
        var settings = $.extend({
            timeToHide:1200, // Default Time to hide fakeLoader
            pos:'fixed',// Default Position
            top:'0px',  // Default Top value
            left:'0px', // Default Left value
            width:'100%', // Default width
            height:'100%', // Default Height
            zIndex: '2000',  // Default zIndex
            bgColor: '#00000099', // Default background color
            spinner:'spinner2', // Default Spinner
            imagePath:'' // Default Path custom image
        }, options);
        //Customized Spinners
        var spinner01 = '<div class="fl spinner1"><div class="double-bounce1"></div><div class="double-bounce2"></div></div>';
        var spinner02 = '<div class="fl spinner2"><div class="spinner-container container1"><div class="circle1"></div><div class="circle2"></div><div class="circle3"></div><div class="circle4"></div></div><div class="spinner-container container2"><div class="circle1"></div><div class="circle2"></div><div class="circle3"></div><div class="circle4"></div></div><div class="spinner-container container3"><div class="circle1"></div><div class="circle2"></div><div class="circle3"></div><div class="circle4"></div></div></div>';
        var spinner03 = '<div class="fl spinner3"><div class="dot1"></div><div class="dot2"></div></div>';
        var spinner04 = '<div class="fl spinner4"></div>';
        var spinner05 = '<div class="fl spinner5"><div class="cube1"></div><div class="cube2"></div></div>';
        var spinner06 = '<div class="fl spinner6"><div class="rect1"></div><div class="rect2"></div><div class="rect3"></div><div class="rect4"></div><div class="rect5"></div></div>';
        var spinner07 = '<div class="fl spinner7"><div class="circ1"></div><div class="circ2"></div><div class="circ3"></div><div class="circ4"></div></div>';
        var cancel = '<button class="fakeloader_cancel_button btn btn-default">cancel / キャンセル</button>'
        spinner02 += cancel
        //The target
        var el = $("#fakeLoader");

        //Init styles
        var initStyles = {
            'background':settings.bgColor,
            'position':settings.pos,
            'width':settings.width,
            'height':settings.height,
            'top':settings.top,
            'left':settings.left,
            "display":"block"
        };

        //Apply styles
        el.css(initStyles);
        //Each
        var a = settings.spinner;
        switch (a) {
            case 'spinner1':
                    el.html(spinner01);
                break;
            case 'spinner2':
                    el.html(spinner02);
                break;
            case 'spinner3':
                    el.html(spinner03);
                break;
            case 'spinner4':
                    el.html(spinner04);
                break;
            case 'spinner5':
                    el.html(spinner05);
                break;
            case 'spinner6':
                    el.html(spinner06);
                break;
            case 'spinner7':
                    el.html(spinner07);
                break;
            default:
                el.html(spinner01);
            }

        if (settings.imagePath !='') {
            el.html('<div class="fl"><img src="'+settings.imagePath+'"></div>');
        }
        centerLoader();

        //Time to hide fakeLoader
        /*setTimeout(function(){
            $("#fakeLoader").fadeOut();
        }, settings.timeToHide);*/

        this.animate({
            'backgroundColor':settings.bgColor,
            'zIndex':settings.zIndex,
        }, 10, 'swing', function() {
            // アニメーションが完了した後に実行される
            callback(data);
        });
        return

    }; // End Fake Loader


        //Center Spinner
    function centerLoader() {

        var winW = $(window).width();
        var winH = $(window).height();

        var spinnerW = $('.fl').outerWidth();
        var spinnerH = $('.fl').outerHeight();
        $('.fl').css({
            'position':'absolute',
            'left':(winW/2)-(spinnerW/2),
            'top':(winH/2)-(spinnerH/2)
        });
    }

    $(window).load(function(){
          $(window).resize(function(){
            centerLoader();
          });
    });


}(jQuery));
