#encoding: utf-8
require "facebook"

class ShareTransferJob < Struct.new(:promotion_badge_id, :member_id, :message)

  def perform
 
    from_member = Member.find(member_id)
    badge = PromotionBadge.find(promotion_badge_id)
    promotion = Promotion.find(badge.promotion_id)
    restaurant = Restaurant.find(promotion.restaurant_id)

    target_member = Member.find(badge.member_id)
 
    fb = FacebookConnector.new(from_member.facebook_id, from_member.access_token)


    fb.post_to_wall(target_member.facebook_id, {
    	:message => message,
    	:link => promotion.url,
    	:name => "เราเพิ่งส่ง #{promotion.name}",
    	:description => promotion.description,
    	:picture => promotion.get_image_url
    });
  end
  
end