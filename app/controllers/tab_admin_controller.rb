class TabAdminController < ApplicationController

  
	layout "blank"


	def index

		if @restaurant
			@promotion = Promotion.get_active(@restaurant.id)
		end

		@marker_pipe = ["color:red", "label:P", @restaurant.location.join(",")]

	end



	before_filter :check_member, :check_restaurant

	private
	def check_member
		@member = Member.create_or_get(session[:facebook_id], session[:page_id], (session[:is_admin] == "yes"))

		if @member.is_page_admin? != true
			render :not_allowed
		end
	end


	def check_restaurant
		@restaurant = Restaurant.first(:conditions => { :facebook_page_id => @member.facebook_page_id })

		if !@restaurant and !(params[:controller] == "tab_restaurant" and params[:action] == "create")
			@restaurant = Restaurant.new
			render "tab_restaurant/new"
			return
		end
	end

end
