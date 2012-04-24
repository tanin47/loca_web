class PromotionController < ApplicationController


	def index

	    radius = 0.1
	     
	    leftTop = [ params[:lat].to_f - radius, params[:lng].to_f - radius ]
	    rightBottom = [ params[:lat].to_f + radius, params[:lng].to_f + radius ]
	    
	    restaurants = Restaurant.where(:location.within => { "$box" => [ leftTop, rightBottom ] }).entries
	    
	    restaurant_hash = {}
	    restaurants.each { |r| restaurant_hash[r.id] = r }


	    promotions = Promotion.where(:restaurant_id.in => restaurants.map { |r| r.id }).where(:status => "ON").entries
	    promotions.each { |p| p.restaurant = restaurant_hash[p.restaurant_id] }
	    promotions = promotions.sort { |a, b| 
	      
			                            distA = Haversine.distance(a.restaurant.location[0], a.restaurant.location[1], params[:lat].to_f, params[:lng].to_f)
			                            distB = Haversine.distance(b.restaurant.location[0], b.restaurant.location[1], params[:lat].to_f, params[:lng].to_f)
			                            
			                            distA <=> distB
			                         }

		badges = []

		if params[:member_id] and params[:member_id] != ""
			badges = PromotionBadge.get_all_from(promotions.map { |p| p.id }, params[:member_id])
		end
	    
	    render :json => {:ok => true,
	                      :restaurants => restaurants.map { |restaurant| restaurant.to_hash },
	                      :promotions => promotions.map { |promotion| promotion.to_hash },
	                      :badges => badges.map { |b| b.to_hash }
	                    }
	end


	def collect

		member = Member.find(params[:member_id])
		promotion = Promotion.find(params[:id])

		badge = promotion.collect(member)

		restaurant = Restaurant.find(promotion.restaurant_id)

		render :json => { :ok => true,
							:restaurant => restaurant.to_hash,
							:promotion => promotion.to_hash,
							:badge => badge.to_hash
						}

	end


	def share

		member = Member.find(params[:member_id])
		promotion = Promotion.find(params[:id])

		Delayed::Job.enqueue ShareJob.new(promotion.id, member.id, params[:message])

		render :json => { :ok => true }

	end


	def transfer

		member = Member.find(params[:member_id])
		promotion = Promotion.find(params[:id])

		target = Member.create_or_get(params[:target_facebook_id])

		badge = promotion.get_badge(member)
		badge.member_id = target.member_id
		badge.save

		Delayed::Job.enqueue ShareTransferJob.new(badge.id, member.id, params[:message])

		render :json => { :ok => true }

	end


end
