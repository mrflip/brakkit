// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){
  $("[rel='twipsy']").each(function (){ $(this).twipsy({}) });

  $("span[rel='popover']").each(function (){
    $(this).popover({
      'offset': 10, 'placement': 'below', 
      'content' : function(){ return $(this).children('.text').text() } })
  }).append('&#8253;').addClass('label').children('.text').hide();

  $(".alert-message").alert();
  $("#flash > div"  ).alert();
})
