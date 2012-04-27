// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var tab_badge_handler = {};

tab_badge_handler.init_list = function(o) {

	function start_loading() {
		$(o.badge_list_panel).html('<img src="http://www.boonthavorn.com/3d/img_load/loading-gif-animation.gif" class="Loading">');
	}

	function stop_loading() {
		$(o.badge_list_panel).html('');
	}

	function load() {

		start_loading();

		$.ajax({
			type: "GET",
			url: "/tab_promotion_badge/" + o.promotion_id,
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
				filter: filter,
				q: $.trim($(o.search_textbox).val())
			},
			success: function(data){

				stop_loading();
				badges.reset();
				for (var i=0;i<data.length;i++) {
					badges.add(new Badge(data[i]));
				}

			},
			error: function(req, status, e){
				alert("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				stop_loading();
			}
		});
	}


	var Badge = Backbone.Model.extend({});
	var badges = new Backbone.Collection();

	badges.on("add", function(badge) {
		badge.on("change:is_used", function() {
			if (this.get('is_used') == true) {
				$('#badge_' + this.cid).addClass("Used");
			} else {
				$('#badge_' + this.cid).removeClass("Used");
			}
		});
	});

	badges.on("add", function(badge) {
		var vars = badge.toJSON();
		vars['cid'] = badge.cid;
		$(o.badge_list_panel).append(Mustache.render(o.list_template_unit, vars));

		if (badge.get('is_used') == true) {
			$('#badge_' + badge.cid).addClass("Used");
		}
	});

	var filter = "all";
	load();

	$(o.all_button).click(function() {
		filter = "all";
		load();
	});

	$(o.unused_button).click(function() {
		filter = "unused";
		load();
	});

	$(o.used_button).click(function() {
		filter = "used";
		load();
	});

	$(o.search_textbox).autocomplete({
										autoFocus: false,
										delay: 100,
										source: "/tab_promotion_badge/" + o.promotion_id + "/autocomplete",
										change: function(event, ui) { 
											load();
										}
									});

	$(o.search_textbox).keyup(function(event) {
		if (event.which == 13) {
			load();
		}
	});


	$(o.badge_list_panel).on("click", ".ToggleUsageButton", function(event) {
		
		var self = event.target;
		var badge_cid = $(self).attr('data-ref');
		var badge = badges.getByCid(badge_cid);

		$(self).loading_button(true);

		$.ajax({
			type: "POST",
			url: "/tab_promotion_badge/" + badge.get('id') + "/toggle",
			cache: false,
			headers: {
				"Connection": "close"
			},
			data: {
			},
			success: function(data){

				$(self).loading_button(false);

				badge.set('is_used', data.is_used);
			},
			error: function(req, status, e){
				alert("ไม่สามารถติดต่อกับระบบได้ กรุณารอ 2 นาทีแล้วลองอีกครั้ง");
				$(self).loading_button(false);
			}
		});
	});

}
