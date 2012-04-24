(function($){

 	$.fn.extend({ 
	
		loading_icon:function(enabled)
		{
			return this.each(function() {
				
				if (enabled == true)
				{
					if (this.loading == true) return;
					this.loading = true;
					this.save_background = $(this).css('background-image');
					
					$(this).css('background-image','url(/loading_button/loading.gif)');

					var x = ($(this).width() - 16) / 2;
					var y = ($(this).height() - 11) / 2;

					$(this).css('background-position', x + 'px ' + y + 'px');

					//$(this).html('<span style="display:inline-block;width:100%;height:100%;vertical-align:top;background-image:url(/loading_button/loading.gif);background-repeat:no-repeat;" onclick="if (event.stopPropagation) event.stopPropagation();event.cancelBubble = true;return false;"></span>');
				}
				else
				{
					if (this.loading == undefined || this.loading == false) return;
					this.loading = false;
					$(this).html('');
					$(this).css('background-image',this.save_background);
					$(this).css('background-position', '');
				}
			
    		});
			
		},
 		
		//pass the options variable to the function
 		loading_button: function(enabled,options) {


			//Set the default values, use comma to separate the settings, example:
			var defaults = {
				image : '<img src="/loading_button/loading.gif">',
				word: ''
			}
				
			var options =  $.extend(defaults, options);

    		return this.each(function() {
				
				if (enabled == true)
				{
					var inside_content = $(this).html();
					//var action = $(this).attr('onclick');
					
					//$(this).html('<span style="display:block;width:100%;height:100%;" onclick="if (event.stopPropagation) event.stopPropagation();event.cancelBubble = true;">'+options.image + ' ' + options.word+'</span>');
					$(this).html('<span style="display:inline-block;width:100%;height:100%;" onclick="if (event.stopPropagation) event.stopPropagation();event.cancelBubble = true;return false;">'+options.image + ' ' + options.word+'</span>');
					
					$(this).append('<span class="loading_button_hidden_div" style="display: none;">'+inside_content+'</span>');
					//$(this).append('<span class="loading_button_hidden_div_action" style="display: none;">'+action+'</span>');
				}
				else
				{
					var hidden_div = $('.loading_button_hidden_div',this);
					//var hidden_div_action = $('.loading_button_hidden_div_action',this);
					
					if (hidden_div.length == 0) return;
					
					$(this).html($(hidden_div).html());
					//alert($(hidden_div_action).html())
					//$(this).attr('onclick',$(hidden_div_action).html());
				}
			
    		});
		},


		//pass the options variable to the function
 		loading_textbox: function(enabled,options) {


			return this.each(function() {
				
				if (enabled == true)
				{
					if (this.loading == true) return;
					this.loading = true;
					this.save_background = $(this).css('background-image');
					$(this).css('background-image','url(/loading_button/loading.gif)');
					$(this).css('background-position','98% 5px');
					$(this).css('background-repeat','no-repeat');
					$(this).prop('disabled', true);

				}
				else
				{
					if (this.loading == undefined || this.loading == false) return;
					this.loading = false;
					$(this).html('');
					$(this).css('background-image',this.save_background);
					$(this).css('background-position','');
					$(this).css('background-repeat','');
					$(this).prop('disabled', false);
;
				}
			
    		});
    	}
	});
	
})(jQuery);

