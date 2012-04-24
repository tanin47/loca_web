class ShareJob < Struct.new(:promotion_id, :member_id, :message)

  def perform
 
    member = Member.find(promotion_id)
    promotion = Promotion.find(member_id)
    restaurant = Restaurant.find(promotion.restaurant_id)
 
    fb = FacebookConnector.new(member.facebook_id, member.access_token)

    fb.post_to_wall(message)
  end
  
end