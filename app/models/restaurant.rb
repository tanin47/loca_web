#encoding: utf-8
class Restaurant
	include Mongoid::Document
	include UniqueIdentity

	field :facebook_page_id, :type => String, :default => ""
    field :name, :type => String
    field :description, :type => String, :default => ""
    field :location, :type => Array, :default => lambda { [0, 0] }
    field :telephone_number, :type => String, :default => ""
    field :website, :type => String, :default => ""
    field :image_path, :type => String, :default => ""

    field :created_date, :type => Time, :default => lambda { Time.now.to_i }

    index [[ :facebook_page_id, Mongo::DESCENDING ]], :unique => true
    index [[ :location, Mongo::GEO2D ]]


    def to_hash 
        { :id => self.id,
            :name => self.name,
            :description => self.description,
            :latitude => self.location[0],
            :longitude => self.location[1],
            :telephone_number => self.telephone_number,
            :website => self.website,
            :thumbnail_url => self.get_image_url }
    end


    def has_image?
        return (self.image_path != "" and self.image_path != nil)
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

end


class Restaurant

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


class Restaurant

    validates_presence_of :name, :message => "กรุณาใส่ชื่อร้านอาหาร"
    validates_presence_of :facebook_page_id, :message => "Facebook Page ผิดพลาด กรุณาลองใหม่"

end