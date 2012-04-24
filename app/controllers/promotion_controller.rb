class PromotionController < ApplicationController


	def index

	    radius = 0.1
	    
	    if params[:keyword] and params[:keyword] != ""
	      radius = 0.3
	    end
	     
	    leftTop = [ params[:lat].to_f - radius, params[:lng].to_f - radius ]
	    rightBottom = [ params[:lat].to_f + radius, params[:lng].to_f + radius ]
	    
	    promotions = Promotion.where(:status => "ON").where(:location.within => { "$box" => [ leftTop, rightBottom ] }).entries

	    promotions = promotions.sort { |a, b| 
	      
			                            distA = Haversine.distance(a.location[0], a.location[1], params[:lat].to_f, params[:lng].to_f)
			                            distB = Haversine.distance(b.location[0], b.location[1], params[:lat].to_f, params[:lng].to_f)
			                            
			                            distA <=> distB
			                         }

		badges = PromotionBadge.get_all_from(promotions.map { |p| p.id }, @member.id)
	    
	    restaurant_ids = promotions.map { |promotion| promotion.restaurant_id }
	    restaurants = Restaurant.all(:conditions => {:_id.in => restaurant_ids})
	    
	    render :json => {:ok => true,
	                      :restaurants => restaurants.map { |restaurant| restaurant.to_hash },
	                      :promotions => promotions.map { |promotion| promotion.to_hash },
	                      :badges => badges.map { |b| b.to_hash }
	                    }
	end


	def collect

	end


	def share

	end


	def transfer

	end


end
