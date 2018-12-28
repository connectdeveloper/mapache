$(document).foundation();


//toggle the clases on the buttons and elements for the content gate
$(".c-main-content__button").click(function() {
        console.log("click");
        $(".c-header").toggleClass("is-half");
        $(".c-main-content__button").toggleClass("is-closed");
        $(".c-main-content__button").toggleClass("is-open");
        $(".c-main-content").toggleClass("is-closed");
        $(".c-main-content").toggleClass("is-open");
        $(".c-main-content__footer").toggleClass("is-closed");
        $(".c-main-content__footer").toggleClass("is-open");
        $(".c-block--tabs").toggleClass("is-up");
        $(".c-block--tabs").toggleClass("is-down");
        $(".c-main-content__button--top:contains('READ MORE')").text("HIDE");
        $(".c-main-content__button--top.is-closed:contains('HIDE')").text("READ MORE");
        $(".c-main-content__button--bottom:contains('READ MORE')").text("HIDE");
        $(".c-main-content__button--bottom.is-closed:contains('HIDE')").text("READ MORE");
        $(".c-main-content__button--top:contains('LEER MÁS')").text("ESCONDER");
        $(".c-main-content__button--top.is-closed:contains('ESCONDER')").text("LEER MÁS");
        $(".c-main-content__button--bottom:contains('LEER MÁS')").text("ESCONDER");
        $(".c-main-content__button--bottom.is-closed:contains('ESCONDER')").text("LEER MÁS");
        return false;
    });

// scroll to top of page
  $(".c-main-content__button--bottom, #c-footer--backtotop").click(function() {
        //  $(body).animate({ scrollTop: 0 }, "slow");
         $(document).scrollTop(0);

     });



//- make the whole block in listings or event clickable
 $(".c-event--plain,.c-event--premium,.c-listing, .primary, .c-listing--secondary, .c-event--common").click(function() {
        var href = $(this).find("a").attr("href");
        if (href) {
            window.location = href;
        }
    });

// hover the link when hovering the div
    // $(".c-event,.c-listing").hover(function(){
    //   $(".c-event__link, .c-listing__link").toggleClass("hover");
    //   console.log("div was hovered");
    // });​

// mini nav toggler
 $(".c-mininav__toggler").click(function() {
        $(".c-mininav__toggler").toggleClass("is_open");
        $(".wrapper").toggleClass("is-extended");
        $(".c-mininav__container").toggleClass("is-extended");
        $(".c-mininav__container").toggleClass("is-collapsed");
        return false;
    });

 // $(".c-mininav__toggler").click(function() {
 //        $("#c-mininav__container.is_extended").toggleClass("is_collapsed");
 //        return false;
 //




$( ".c-header__heroimage" ).clone().prependTo( ".c-main-content__footer.is-closed .c-hero-image__frame" );
$(".c-slider--page").detach().appendTo(".c-block__column > p:first");
// $(".c-slider.c-slider--page.slick-initialized.slick-slider").detach().appendTo(".c-block.c-single__content.c-single__content--page .c-block__column > p");

if ( ! Modernizr.objectfit ) {
$('.c-hero-image__frame, .c-header__framer').each(function () {
var $container = $(this),
imgUrl = $container.find('img').prop('src');
    if (imgUrl) {
$container
.css('backgroundImage', 'url(' + imgUrl + ')')
.addClass('compat-object-fit');
}
});
}
 

$(".c-button.c-button--secondary").click(function() {
        console.log("click");
        // if this(html)==""
        $(this).closest(".c-transfer-block").find(".c-transfer-block__full-prices").toggleClass("is-closed");
        $(this).closest(".c-transfer-block").find(".c-transfer-block__full-prices:contains('ESCONDER')").toggleClass("is-closed");
        var buttonText = $(this).text();
        if(buttonText.match("SEE PRICES")) {
        $(this).text("HIDE PRICES");
        };
        // $(this).text().match('HIDE PRICES').text("SEE PRICES");     
        // $(this).text().match('SEE PRICES').text("HIDE PRICES");
        
        // else if ($(this).text().match('ESCONDER PRECIOS')){
        //     $(this).text("VER PRECIOS")
        // } else if ($(this).text().match('VER PRECIOS')){
        //     $(this).text("ESCONDER PRECIOS")
        // }
         
        // $(this":contains('HIDE PRICES')").text("SEE PRICES");
        // $(this":contains('VER PRECIOS')").text("ESCONDER PRECIOS");
        // $(this":contains('ESCONDER PRECIOS')").text("VER PRECIOS");

        return false; 
    });

// hello
// $('.c-event__image-and-mast').equalize({children: '.c-image__frame',equalize: 'width' });
// $('.c-event__image-and-mast').equalize({children: '.c-image__frame',equalize: 'height' });
// // $('.c-event__image-and-mast').equalize({equalize: 'width', equalize: 'height');

// $( window ).resize(function() {
//   $('.c-event__image-and-mast').equalize({children: '.c-image__frame',equalize: 'width', reset: 'true'});
//   $('.c-event__image-and-mast').equalize({children: '.c-image__frame',equalize: 'height', reset: 'true' });
// });



