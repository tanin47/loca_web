class PromotionController < ApplicationController


	def index

	    radius = 0.1

	     
	    leftTop = [ params[:lat].to_f - radius, params[:lng].to_f - radius ]
	    rightBottom = [ params[:lat].to_f + radius, params[:lng].to_f + radius ]
	    
	    restaurants = []
	    if Rails.env.development?
			restaurants = Restaurant.desc(:created_date).entries
	    else
	    	restaurants = Restaurant.desc(:created_date).entries
	    	# restaurants = Restaurant.where(:location.within => { "$box" => [ leftTop, rightBottom ] }).entries
	    end

	    restaurant_hash = {}
	    restaurants.each { |r| restaurant_hash[r.id] = r }

	    promotions = Promotion.where(:restaurant_id.in => restaurants.map { |r| r.id }).where(:status => "ON").where(:start_date.lte => Time.now.to_date).where(:end_date.gte => Time.now.to_date).entries
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

		if !promotion.collectable?
			render :json => { :ok => false,
								:error_message => promotion.incollectable_error_message }
			return
		end

		badge = promotion.collect(member)

		restaurant = Restaurant.find(promotion.restaurant_id)

		render :json => { :ok => true,
							:restaurant => restaurant.to_hash,
							:promotion => promotion.to_hash,
							:badge => badge.to_hash,
							:member => member.to_hash
						}

	end


	def share

		member = Member.find(params[:member_id])
		promotion = Promotion.find(params[:id])

		share_record = ShareRecord.get(member, promotion)

		Rails.logger.warn { share_record.id }

	    if !share_record or (Time.now - share_record.created_date) > (60 * 60)
	        member.inc(:point, 1)
	        ShareRecord.safely.create(:member_id => member.id,
	                                    :promotion_id => promotion.id)
	    end

		Delayed::Job.enqueue ShareJob.new(promotion.id, member.id, params[:message])

		render :json => { :ok => true,
							:member => member.to_hash }

	end


	def show
		@promotion = Promotion.find(params[:id])
	end



end
