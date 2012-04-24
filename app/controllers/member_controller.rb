class MemberController < ApplicationController


	def badges

		badges = PromotionBadge.where(:member_id => params[:id]).desc(:created_date).entries
		promotions = Promotion.where(:_id.in => badges.map { |b| b.promotion_id }).entries
		restaurants = Restaurant.where(:_id.in => promotions.map { |p| p.restaurant_id }).entries

		render :json => {:ok => true,
	                      :restaurants => restaurants.map { |restaurant| restaurant.to_hash },
	                      :promotions => promotions.map { |promotion| promotion.to_hash },
	                      :badges => badges.map { |b| b.to_hash }
	                    }
	end

end
