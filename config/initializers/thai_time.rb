# encoding: utf-8
[Time, Date, DateTime].each { |k|
  
	k.class_eval {
		@@months = ["มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]

		def to_thai_date
		  return "#{self.day} #{@@months[self.month-1]} #{(self.year+543)}"
		end

		def to_thai_time
		  return "#{self.hour}:#{"%02d" % self.min}น."
		end

		def to_thai_datetime
		  	return "#{self.to_thai_date} #{to_thai_time}"
		  end
	}
  
}
