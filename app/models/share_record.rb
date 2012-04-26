class ShareRecord
	include Mongoid::Document

	field :member_id, :type => String, :default => ""
	field :promotion_id, :type => String, :default => ""

    field :created_date, :type => Time, :default => lambda { Time.now.to_i }

    def self.get(member, promotion)
    	return self.desc(:created_date).where(:member_id => member.id).where(:promotion_id => promotion_id).first
    end

end