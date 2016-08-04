// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ahoy
//  require turbolinks
//= require Chart.bundle
//= require chartkick
//= require_tree .

ahoy.trackAll();

// $("#customer_drop_off_date").datepicker({
//   showOn: "both",
//   onSelect: function(dateText, inst){
//      $("#customer_pick_up_date").datepicker("option","minDate",
//      $("#customer_drop_off_date").datepicker("getDate"));
//   }
// });

// $("#customer_drop_off_date").datepicker({
//     dateFormat: 'yy-mm-dd',
//     changeMonth: true,
//     minDate: new Date(),
//     maxDate: '+1y',
//     onSelect: function(date){
//       var selectedDate = new Date(date);
//       var msecsInADay = 86400000;
//       var endDate = new Date(selectedDate.getTime() + msecsInADay);
//       $("#customer_pick_up_date").datepicker( "option", "minDate", endDate );
//       $("#customer_pick_up_date").datepicker( "option", "maxDate", '+1y' );
//     }
// });
//
// $("#customer_pick_up_date").datepicker({
//     dateFormat: 'yy-mm-dd',
//     changeMonth: true
// });
// minDate: new Date(2016, 12 - 1, 15)

$(function() {
  $(".datepicker_drop_off").datepicker({
    minDate: 0
  });
});

$(function() {
  $('.datepicker_pick_up').datepicker({
    minDate: 0
  });
});

$(function() {
  $('.holiday_datepicker').datepicker({
    minDate: 0
  });
});

$(function() {
  $('.blog_publish_date_picker').datepicker({
    minDate: 0
  });
});
