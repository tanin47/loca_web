// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var tab_badge_handler = {};

tab_badge_handler.init_list = function(o) {

	$(o.usage_buttons).click(function() {
		
		var self = this;
		var badge_id = $(self).attr('data-ref');

		$(self).loading_button(true);

		$.ajax({
			type: "POST",
			url: "/tab_promotion_badge/" + badge_id + "/toggle",
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
			},
			success: function(data){

				$(self).loading_button(false);

				if (data.is_used == true) {
					$(self).parents(".Badge").addClass("Used");
				} else {
					$(self).parents(".Badge").removeClass("Used");
				}

			},
			error: function(req, status, e){
				alert("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				$(self).loading_button(false);
			}
		});
	});

}
