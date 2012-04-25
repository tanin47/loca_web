#encoding: utf-8
class PromotionBadgeController < ApplicationController

	def transfer

		member = Member.find(params[:member_id])
		badge = PromotionBadge.find(params[:id])

		target = Member.create_or_get(params[:target_facebook_id])

		promotion = Promotion.find(badge.promotion_id)

		if promotion.get_badge(target) != nil
			render :json => { :ok => false, :error_message => "เพื่อนคุณมี Promotion นี้อยู่แล้ว"}
			return
		end 

		badge.member_id = target.id
		badge.safely.save

		Delayed::Job.enqueue ShareTransferJob.new(badge.id, member.id, params[:message])

		render :json => { :ok => true }

	end

end
