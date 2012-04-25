require "facebook"

class ShareJob < Struct.new(:promotion_id, :member_id, :message)

  def perform
 
    member = Member.find(member_id)
    promotion = Promotion.find(promotion_id)
    restaurant = Restaurant.find(promotion.restaurant_id)
 
    fb = FacebookConnector.new(member.facebook_id, member.access_token)

    fb.post_to_wall(member.facebook_id, {
    	:message => message,
    	:link => promotion.url,
    	:name => promotion.name,
    	:description => promotion.description,
    	:picture => promotion.get_image_url
    });
  end
  
end