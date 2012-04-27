class TabPromotionController < TabAdminController


	def index
		@promotions = Promotion.where(:restaurant_id => @restaurant.id).desc(:start_date).entries
	end


	def show
		@promotion = Promotion.find(params[:id])
	end


	def new
		@promotion = Promotion.new
	end


	def create

		promotion = Promotion.create(:restaurant_id => @restaurant.id,
										:name => params[:name],
										:image_path => params[:image_path],
										:description => params[:description],
										:start_date => DateTime.strptime(params[:start_date], "%Y-%m-%d"),
										:end_date => DateTime.strptime(params[:end_date], "%Y-%m-%d"),
										:total => params[:total]
										)

		if promotion.invalid?
			render :json => { :ok => false,
								:error_messages => promotion.errors
								}

			return
		end


		render :json => { :ok => true, :promotion_id => promotion.id }

	end


	def edit
		@promotion = Promotion.find(params[:id])
		render :new
	end


	def update

		promotion = Promotion.find(params[:id])
		promotion.name = params[:name]
		promotion.image_path = params[:image_path]
		promotion.description = params[:description]
		promotion.start_date = DateTime.strptime(params[:start_date], "%Y-%m-%d")
		promotion.end_date = DateTime.strptime(params[:end_date], "%Y-%m-%d")
		promotion.total = params[:total]

		if promotion.invalid?
			render :json => { :ok => false,
								:error_messages => promotion.errors
								}

			return
		end

		promotion.save

		render :json => { :ok => true, :promotion_id => promotion.id }

	end


	def toggle

		promotion = Promotion.find(params[:id])
		promotion.toggle_status
		
		if promotion.is_active?
			active = Promotion.get_active(@restaurant.id)

			if active
				active.deactivate
				active.safely.save
			end
		end

		promotion.safely.save

		active = Promotion.get_active(@restaurant.id)
		active_id = ""
		active_id = active.id if active

		render :json => { :ok => true, :promotion_id => active_id }

	end

end
