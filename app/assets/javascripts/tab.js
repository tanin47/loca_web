// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var  tab_handler = {};

tab_handler.goto = function(url, button) {

	$('body > .Body').html('<img src="http://www.boonthavorn.com/3d/img_load/loading-gif-animation.gif" class="Loading">');

	$.get(url, function(data) {
		$('body > .Body').html(data);
		FB.Canvas.setSize();
	});
}
