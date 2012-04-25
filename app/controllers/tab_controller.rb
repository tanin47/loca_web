class TabController < ApplicationController


	def index

		@promotion = nil
		if @restaurant
			@promotion = Promotion.get_active(@restaurant.id)
		end

		if request.xhr?
			render :index, :layout => "blank"
		else
			render :index, :layout => "tab"
		end
	end


	before_filter :check_for_tab_added, :verify_signed_request, :check_member

	private
	def check_for_tab_added
		if params[:tabs_added]
			redirect_to "/home/thank_you_for_adding"
		end
	end


	def verify_signed_request

		return if request.xhr?

		encoded_signature, payload = params[:signed_request].split(".")

		new_payload = payload
		new_payload += '=' while ((new_payload.length%4) > 0)
		encoded_signature += '=' while ((encoded_signature.length%4) > 0)

		Rails.logger.warn { Base64.urlsafe_decode64(new_payload) }
		@data = ActiveSupport::JSON.decode(Base64.urlsafe_decode64(new_payload))
		signature = Base64.urlsafe_decode64(encoded_signature);


		expected_signature = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha256'), APP_SECRET, payload)

		Rails.logger.warn { signature }
		Rails.logger.warn { expected_signature }

		if signature != expected_signature
			render :bad_signed_request
		end

		session[:facebook_id] = @data["user_id"]
		session[:page_id] = @data["page"]["id"]
		session[:is_admin] = (@data["page"]["admin"] == true) ? "yes" : "no"

	end


	def check_member
		@member = Member.create_or_get(session[:facebook_id], session[:page_id], (session[:is_admin] == "yes"))
		@restaurant = Restaurant.first(:conditions => { :facebook_page_id => @member.facebook_page_id })
	end

end
