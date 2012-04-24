// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var  tab_handler = {};

tab_handler.goto = function(url) {
	$.get(url, function(data) {
		$('body > .Body').html(data);
		FB.Canvas.setSize();
	});
}
