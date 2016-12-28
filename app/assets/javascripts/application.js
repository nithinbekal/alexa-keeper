// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
function getGraph(alexa_rank_json) {
  alexa_rank_json['yAxis']['labels']['formatter'] =
            function()
            {var rate = this.value;
              if (rate>999999)
              {
                rate = Math.round((rate/1000000)*100)/100+" M";
              }
              else if(rate>999 && rate<1000000)
              {
                rate = Math.round((rate/1000)*100)/100+" k";
              }
              return rate;
            }
  $(document).ready(function() {
  $('#graph').highcharts(alexa_rank_json);
});
}
(function($) {
    "use strict"; // Start of use strict
    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: ($($anchor.attr('href')).offset().top - 50)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    // Highlight the top nav as scrolling occurs
    $('body').scrollspy({
        target: '.navbar-fixed-top',
        offset: 100
    });

    // Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function() {
        $('.navbar-toggle:visible').click();
    });

    // Offset for Main Navigation
    $('#mainNav').affix({
        offset: {
            top: 50
        }
    });
    var slider = ["ALERT","SMART","COMPETITIVE","IN BUSINESS"];
    var i = 0;
    window.setInterval(function(){
        if(i>=slider.length) {
            i=0;
        }
        $("#animate").text(slider[i]);
        i++;
    }, 3000);

})(jQuery); // End of use strict
