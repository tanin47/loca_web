// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var tab_restaurant = {};

tab_restaurant.init_form = function(o) {


	function get_current_location(callback) {

		if(navigator.geolocation) {

			navigator.geolocation.getCurrentPosition(function(position) {

				var loc = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
				callback(loc);
				

			}, function() {});

		} else if (google.gears) {
			
			var geo = google.gears.factory.create('beta.geolocation');
			geo.getCurrentPosition(function(position) {

			  var loc = new google.maps.LatLng(position.latitude,position.longitude);
			  callback(loc);

			}, function() {});	

		}

	}

	var map;
	if (o.latitude == null || o.longitude == null) {

		o.latitude = 13.723377;
		o.longitude = 100.476151;

		get_current_location(function(location) {
	    	map.setCenter(location);
	    });
	}

    map = new google.maps.Map(o.map_canvas, {
      center: new google.maps.LatLng(o.latitude, o.longitude),
      zoom: 12,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
	  scaleControl: true
    });

    google.maps.event.addListenerOnce(map, 'idle', function(){
		FB.Canvas.setSize();
	});

    var marker = new google.maps.Marker({
	    map: map,
	    draggable: false,
	    animation: google.maps.Animation.DROP
	});

	marker.bindTo('position', map, 'center');

    

    var logo_path = "";
    $(o.logo_upload_button).ajax_uploader({
												action: "/temporary_file/image",
												params:{
													max_width: 100
												},
												name:"Filedata",
												debug:false,
												multiple:false,
												allowedExtensions: ["gif","jpg","jpeg","png"],
												onSubmit: function(fileId, fileName){
													o.logo_preview.src = "/ajax_loader/loading.gif";
												},
										        onProgress: function(fileId, fileName, loaded, total){
													
												},
										        onComplete: function(fileId, fileName, responseJSON){

										        	o.logo_preview.src = "";
													
													if (responseJSON.ok != true) {
														alert(responseJSON.error_messages);
														return;
													}
													
													o.logo_preview.src = responseJSON.filename;
													logo_path = responseJSON.filename;
												},
										        onCancel: function(fileId, fileName){
													o.logo_preview.src = "";
												}
											});

    $(o.submit_button).click(function() {


		var explanation_map = { location: o.map_canvas,
								name: o.name,
								description: o.description,
								telephone_number: o.telephone_number,
								website: o.website
								};

		$.clear_error(explanation_map);
		$(o.summary_panel).clear_error();

		$(o.submit_button).loading_button(true);

		var point = map.getCenter();

		$.ajax({
			type: "POST",
			url: "/tab_restaurant",
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
				latitude: point.lat(),
				longitude: point.lng(),
				name: $(o.name).val(),
				image_path: logo_path,
				description: $(o.description).val(),
				telephone_number: $(o.telephone_number).val(),
				website: $(o.website).val()
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
					tab_handler.goto('/tab_admin');
				}
			},
			error: function(req, status, e){
				$(o.summary_panel).show_error("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				$(o.submit_button).loading_button(false);
			}
		});
    });
};