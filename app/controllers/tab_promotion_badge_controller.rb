class TabPromotionBadgeController < ApplicationController

	def toggle

		badge = PromotionBadge.find(params[:id])

		badge.is_used = !badge.is_used
		badge.save

		render :json => { :ok => true, :is_used => badge.is_used }

	end

end
