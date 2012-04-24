class ShareTransferJob < Struct.new(:promotion_badge_id, :member_id, :message)

  def perform
 
    from_member = Member.find(member_id)
    badge = PromotionBadge.find(promotion_badge_id)
    promotion = Promotion.find(badge.promotion_id)
    restaurant = Restaurant.find(promotion.restaurant_id)
 
    fb = FacebookConnector.new(from_member.facebook_id, from_member.access_token)

    fb.post_to_wall(message)
  end
  
end