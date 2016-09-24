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
//= require ckeditor/init
//= require Chart.bundle
//= require chartkick
//= require_tree .

ahoy.trackAll();
//
// var today = new Date();
// var dd = today.getDate();
// var mm = today.getMonth()+1; //January is 0!
//
// var yyyy = today.getFullYear();
// if(dd<10){
//     dd='0'+dd
// }
// if(mm<10){
//     mm='0'+mm
// }
// var today = mm+'/'+dd+'/'+yyyy;


$(function() {
  $(".daterange_check_in").daterangepicker({
    minDate: moment(),
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
