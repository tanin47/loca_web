class TabRestaurantController < TabAdminController

	def index
		new
	end


	def new

		#@restaurant = Restaurant.first(:conditions => { :facebook_page_id => @member.facebook_page_id })
		@restaurant = Restaurant.new if !@restaurant

		render :new

	end


	def create

		#restaurant = Restaurant.first(:conditions => { :facebook_page_id => @member.facebook_page_id })
		@restaurant = Restaurant.new if !@restaurant

		@restaurant.facebook_page_id = @member.facebook_page_id
		@restaurant.name = params[:name]
		@restaurant.description = params[:description]
		@restaurant.location = [params[:latitude], params[:longitude]]
		@restaurant.telephone_number = params[:telephone_number]
		@restaurant.website = params[:website]
		@restaurant.image_path = params[:image_path]

		if @restaurant.invalid?
			render :json => { :ok => false,
								:error_messages => @restaurant.errors
								}

			return
		end


		@restaurant.save

		render :json => { :ok => true }

	end

end
