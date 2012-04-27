class TabPromotionBadgeController < ApplicationController

	def toggle

		badge = PromotionBadge.find(params[:id])

		badge.is_used = !badge.is_used
		badge.save

		render :json => { :ok => true, :is_used => badge.is_used }

	end


	def index
		badges = PromotionBadge.where(:promotion_id => params[:promotion_id]).desc(:created_date)

		if params[:filter] == "used"
			badges = badges.where(:is_used => true)
		elsif params[:filter] == "unused"
			badges = badges.where(:is_used => false)
		end

		if params[:q] and params[:q] != ""
			badges = badges.where(:number_keywords => params[:q])
		end

		badges = badges.entries

		render :json => badges.map { |b| b.to_hash }
	end


	def autocomplete
		badges = PromotionBadge.where(:promotion_id => params[:promotion_id]).where(:number_keywords => params[:term]).desc(:created_date).entries
		render :json => badges.map { |b| b.number }
	end

end
