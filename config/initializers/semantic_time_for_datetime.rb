class DateTime
  
  SECONDS_IN_ONE_MINUTE = 60
  SECONDS_IN_ONE_HOUR = (60 * 60)
  SECONDS_IN_ONE_DAY = (60 * 60 * 24)
  SECONDS_IN_ONE_MONTH = (60 * 60 * 24 * 30)
  SECONDS_IN_ONE_YEAR = (60 * 60 * 24 * 30 * 12)
  
  def semantic_time
    
    str = ""
    suffix = "ago"
    
    duration = Time.now - self
    
    if duration < 0
      suffix = "left"
      duration = -duration
    end
   
   if duration >= 0 and duration < SECONDS_IN_ONE_MINUTE
     
     if duration.to_f.round >= 0 and duration.to_f.round <= 3
        str = "a few seconds " + suffix
      else
        str = duration.to_f.round.to_s + " seconds " + suffix
      end
      
    elsif duration >= SECONDS_IN_ONE_MINUTE and duration < SECONDS_IN_ONE_HOUR
      
      str = (duration / SECONDS_IN_ONE_MINUTE).to_f.round.to_s
      
      if (duration / SECONDS_IN_ONE_MINUTE).to_f.round == 1
        str += " minute " + suffix
      else
        str += " minutes " + suffix
      end
      
    elsif duration >= SECONDS_IN_ONE_HOUR and duration < SECONDS_IN_ONE_DAY
      
      str = (duration / SECONDS_IN_ONE_HOUR).to_f.round.to_s
      
      if (duration / SECONDS_IN_ONE_HOUR).to_f.round == 1
        str += " hour " + suffix
      else
        str += " hours " + suffix
      end
      
    elsif duration >= SECONDS_IN_ONE_DAY and duration < SECONDS_IN_ONE_MONTH
      
      str = (duration / SECONDS_IN_ONE_DAY).to_f.round.to_s
      
      if (duration / SECONDS_IN_ONE_DAY).to_f.round == 1
        str += " day " + suffix
      else
        str += " days " + suffix
      end
      
    elsif duration >= SECONDS_IN_ONE_MONTH and duration < SECONDS_IN_ONE_YEAR
      
      str = (duration / SECONDS_IN_ONE_MONTH).to_f.round.to_s 
      
      if (duration / SECONDS_IN_ONE_MONTH).to_f.round == 1
        str += " month " + suffix
      else
        str += " months " + suffix
      end
      
    elsif duration >= SECONDS_IN_ONE_YEAR
      
      str = (duration / SECONDS_IN_ONE_YEAR).to_f.round.to_s
      
      if (duration / SECONDS_IN_ONE_YEAR).to_f.round == 1
        str += " year " + suffix
      else
        str += " years " + suffix
      end
      
    end
      
    return str
    
  end
  
end