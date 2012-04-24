// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var tab_promotion_handler = {};

tab_promotion_handler.init_list = function(o) {

	$(o.activate_buttons).click(function() {
		
		var self = this;
		var promotion_id = $(self).attr('data-ref');

		$(self).loading_icon(true);

		$.ajax({
			type: "POST",
			url: "/tab_promotion/" + promotion_id + "/toggle",
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
			},
			success: function(data){

				$(self).loading_icon(false);

				for (var i=0;i<o.activate_buttons.length;i++) {

					var this_id = $(o.activate_buttons[i]).attr('data-ref');

					if (this_id == data.promotion_id) {
						$(o.activate_buttons[i]).addClass('Active');
					} else {
						$(o.activate_buttons[i]).removeClass('Active');
					}
					
				}
			},
			error: function(req, status, e){
				alert("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				$(self).loading_icon(false);
			}
		});
	});

}

tab_promotion_handler.init_form = function(o) {


	var image_path = "";
    $(o.image_upload_button).ajax_uploader({
												action: "/temporary_file/image",
												params:{
													max_width: 100
												},
												name:"Filedata",
												debug:false,
												multiple:false,
												allowedExtensions: ["gif","jpg","jpeg","png"],
												onSubmit: function(fileId, fileName){
													o.image_preview.src = "/ajax_loader/loading.gif";
												},
										        onProgress: function(fileId, fileName, loaded, total){
													
												},
										        onComplete: function(fileId, fileName, responseJSON){

										        	o.image_preview.src = "";
													
													if (responseJSON.ok != true) {
														alert(responseJSON.error_messages);
														return;
													}
													
													o.image_preview.src = responseJSON.filename;
													image_path = responseJSON.filename;
												},
										        onCancel: function(fileId, fileName){
													o.image_preview.src = "";
												}
											});



	$(o.submit_button).click(function() {


		var explanation_map = { name: o.name,
								description: o.description,
								start_date: o.start_date,
								end_date: o.end_date,
								total: o.total
								};

		$.clear_error(explanation_map);
		$(o.summary_panel).clear_error();

		$(o.submit_button).loading_button(true);

		var url_tail = "";

		if (o.promotion_id != null) url_tail = "/" + o.promotion_id;

		$.ajax({
			type: (o.promotion_id == null) ? "POST" : "PUT",
			url: "/tab_promotion" + url_tail,
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
				name: $(o.name).val(),
				image_path: image_path,
				description: $(o.description).val(),
				start_date: $(o.start_date).val(),
				end_date: $(o.end_date).val(),
				total: $(o.total).val()
			},
			success: function(data){

				if (data.ok != true) {
					$.show_error(data.error_messages, explanation_map);
					$(o.summary_panel).show_error(data.error_messages);
					$(o.submit_button).loading_button(false);
					return;
				}
				else 
				{
					tab_handler.goto('/tab_promotion/' + data.promotion_id);
				}
			},
			error: function(req, status, e){
				$(o.summary_panel).show_error("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				$(o.submit_button).loading_button(false);
			}
		});
    });

};
