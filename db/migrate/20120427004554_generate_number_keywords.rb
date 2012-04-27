class GenerateNumberKeywords < Mongoid::Migration
  def self.up
  	PromotionBadge.all.each { |badge|
  		badge.number += " "
  		badge.save
  	}
  end

  def self.down
  end
end