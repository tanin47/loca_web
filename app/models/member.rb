class Member
	include Mongoid::Document
	include MemberCookies
	include UniqueIdentity

    attr_accessor :is_page_admin, :facebook_page_id

    def is_page_admin?
        return (@is_page_admin == true)
    end

	field :facebook_id, :type=>String, :default => ""
    field :name, :type => String, :default => ""
    field :owns_page_ids, :type => Array, :default => []
    field :cookies_salt, :type=>String, :default => ""
    field :is_admin, :type => Boolean, :default => false
    field :created_date, :type => Time, :default => lambda { Time.now.to_i }

    index [[ :facebook_id, Mongo::DESCENDING ]], :unique => true


    def to_hash
        { :id => self.id,
          :facebook_id => self.facebook_id,
          :name => self.name
        }
    end


    def self.create_or_get(facebook_id, page_id="0", is_page_admin=false)
        member = Member.first(:conditions => { :facebook_id => facebook_id })

        if !member
            member = Member.safely.create(:facebook_id => facebook_id)
        end

        if is_page_admin == true
            member.add_to_set(:owns_page_ids, page_id)
            member.is_page_admin = true
        end

        member.facebook_page_id = page_id

        return member

    end

end