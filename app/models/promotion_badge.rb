#encoding: utf-8
class PromotionBadge
	include Mongoid::Document
	include UniqueIdentity

	field :promotion_id, :type => String
	field :member_id, :type => String

	field :number, :type => String
	field :is_used, :type => Boolean, :default => false

	field :expiration_date, :type => Time

	field :created_date, :type => Time, :default => lambda { Time.now.to_i }


	def is_used?
		return (self.is_used == true)
	end

end