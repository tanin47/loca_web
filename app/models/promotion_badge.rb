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

	field :number_keywords, :type => Array, :default => []


	index [[ :promotion_id, Mongo::DESCENDING ],
			[ :member_id, Mongo::DESCENDING ]], :unique => true

	index [[ :promotion_id, Mongo::DESCENDING ],
			[ :number, Mongo::DESCENDING ]], :unique => true

	index [[ :promotion_id, Mongo::DESCENDING ],
			[ :number_keywords, Mongo::DESCENDING ]]


	index [[ :promotion_id, Mongo::DESCENDING ],
			[ :is_used, Mongo::DESCENDING ],
			[ :number_keywords, Mongo::DESCENDING ]]


	before_save { |record|
		self.number.strip!
		self.number_keywords = []

		self.number.length.times { |i|
			self.number_keywords.push(self.number[0..i])
		}
	}


    def to_hash
        { :id => self.id,
          :promotion_id => self.promotion_id,
          :member_id => self.member_id,
          :number => self.number,
          :is_used => self.is_used
        }
    end


	def is_used?
		return (self.is_used == true)
	end


	def self.get_all_from(promotion_ids, member_id)
		return self.all(:conditions => { :promotion_id.in => promotion_ids, :member_id => member_id})
	end


	before_create :transform_number
	private
	def transform_number

		self.number = "#{rand(10)}#{self.number}" while (self.number.length%4) > 0

		new_number = ""

		self.number.length.times { |i|
			new_number += "-" if ((i%4) == 0 and i > 0)
			new_number += self.number[i].upcase
		}

		self.number = new_number
	end

end