#encoding: utf-8
class Promotion
	include Mongoid::Document
	include UniqueIdentity

    field :name, :type => String
    field :description, :type => String, :default => ""
    field :image_path, :type => String, :default => ""

    field :restaurant_id, :type => String

    field :start_date, :type => Time, :default => lambda { Time.now }
    field :end_date, :type => Time, :default => lambda { (Time.now + 10.days) }

    field :collected_count, :type => Integer, :default => 0
    field :total, :type => Integer, :default => 100
    
    field :status, :type => String, :default => "OFF"
    field :created_date, :type => Time, :default => lambda { Time.now }


    index [ [ :status, Mongo::DESCENDING ],
            [ :start_date, Mongo::DESCENDING ],
            [ :end_date, Mongo::DESCENDING ] ]


    attr_accessor :restaurant


    def to_hash
        { :id => self.id,
          :name => self.name,
          :description => self.description,
          :thumbnail_url => self.image_path,
          :restaurant_id => self.restaurant_id,
          :start_date => self.start_date,
          :end_date => self.end_date,
          :collected_count => self.collected_count,
          :total => self.total
        }
    end


    def self.get_active(restaurant_id)
        return self.first(:conditions => { :restaurant_id => restaurant_id, :status => "ON" })
    end


    def has_image?
        return (self.image_path != "" and self.image_path != nil)
    end


    def path
        "/promotion/#{self.id}"
    end

    def url
        "https://#{DOMAIN_NAME}#{path}"
    end


    def get_image_url
        "https://#{DOMAIN_NAME}#{self.get_image_path}"
    end


    def get_image_path
        if has_image?
            return self.image_path
        else
            return "/assets/default_logo.png"
        end
    end


    def is_active?
        return (self.status == "ON")
    end


    def toggle_status
        if self.status == "OFF"
            self.status = "ON"
        else
            self.status = "OFF"
        end
    end


    def deactivate
        self.status = "OFF"
    end

    def get_badge(member)
        return PromotionBadge.first(:conditions => { :promotion_id => self.id, :member_id => member.id})
    end

    def collect(member)

        badge = PromotionBadge.first(:conditions => { :promotion_id => self.id, :member_id => member.id})

        if !badge
            badge = PromotionBadge.create(:promotion_id => self.id, 
                                            :member_id => member.id,
                                            :number => member.facebook_id.reverse)

            member.inc(:point, 3)
            self.inc(:collected_count, 1)
        end

        return badge

    end


    def collectable?
        return ((self.collected_count < self.total) \
                or (self.start_date <= Time.now and Time.now < self.end_date))
    end


    def incollectable_error_message

        if self.collected_count >= self.total
            "โปรโมชั่นหมดแล้ว"
        elsif self.start_date < Time.now
            "โปรโมชั่นยังไม่เริ่ม"
        elsif self.end_date < Time.now
            "โปรโมชั่นหมดอายุแล้ว"
        else
            ""
        end

    end

end


class Promotion

    before_save :update_image_path

    private
    def update_image_path
        return if !self.image_path_changed?

        if self.image_path_was != nil and self.image_path_was != ""
          FileUtils.remove(self.image_path_was, :force=>true)
        end
        
        return if self.image_path == nil
        return if self.image_path == ""
        
        basename = File.basename(self.image_path)
        new_image_path = "/uploads/#{basename}"
        
        FileUtils.move(File.join(Rails.root, "public", CGI.unescape(self.image_path)), 
                          File.join(Rails.root, "public", CGI.unescape(new_image_path)))
                          
        self.image_path = new_image_path
    end

end


class Promotion

    validates_presence_of :name, :message => "กรุณาใส่ชื่อโปรโมชั่น"

end