class ShareRecord
	include Mongoid::Document

	field :member_id, :type => String, :default => ""
	field :promotion_id, :type => String, :default => ""

    field :created_date, :type => Time, :default => lambda { Time.now.to_i }

    def self.get(member, promotion)
    	return self.first(:conditions => { :member_id => member.id, :promotion_id => promotion.id })
    end

end