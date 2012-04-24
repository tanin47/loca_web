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
//= require jquery
//= require jquery_ujs
//= require_tree .



(function($){

	$.extend({
		clear_error: function(map) {
			for (var k in map) {
				$(map[k]).removeClass('Error');
			}
		},

		show_error: function(error_messages, map) {

			if (!(error_messages instanceof Object)) return;


			for (var k in error_messages) {

				$(map[k]).addClass('Error');
				$(map[k]).next('.Explanation').html(error_messages[k].join(','));
			}
		}
	});

 	$.fn.extend({ 
 		clear_error: function() {
			$(this).removeClass('error');
		},

		show_error: function(error_messages) {

			if ((typeof error_messages).toLowerCase() == "string") {
				error_messages = { "summary": [ error_messages ] };
			}

			$(this).addClass('Error');

			var html = "<ul>";

			for (var k in error_messages) {

				html += "<li>" + error_messages[k].join(',') + "</li>";
			}

			html += "</ul>";

			$(this).html(html);
		},

		show_message: function(msg) {
			$(this).removeClass('Error');
			$(this).html(msg);
		}
 	});

 })(jQuery);
