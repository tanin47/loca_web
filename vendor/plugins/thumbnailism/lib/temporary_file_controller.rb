require 'fileutils'

class TemporaryFileController < ActionController::Base
  include TemporaryFileHelper
  include ThumbnailismHelper
 
  def index
   
    
   
    if !@allow_extensions
      render :json=>{:ok=>false, :error_message=>"Invalid path. Please use /temporary_file/image or /temporary_file/any_file"}
      return
    end
    
    @options = {}
    if params[:max_width]
      @options[:max_width] = params[:max_width]
    end

    begin 
      
      if params[:Filedata].class == String
        
        data_bytes = request.body.read
        filename = upload_temporary_image(data_bytes,
                                          params[:Filedata],
                                          data_bytes.length,
                                          @allow_extensions,
                                          @options)

        response.headers['Content-type'] = 'text/html; charset=utf-8'
        render :json=>{:ok=>true, :filename=>filename}
      
      else
        
        filename= upload_temporary_image(params[:Filedata].read,
                                          params[:Filedata].original_filename,
                                          params[:Filedata].size,
                                          @allow_extensions,
                                          @options)
      
        response.headers['Content-type'] = 'text/plain; charset=utf-8'
        render :text=>ActiveSupport::JSON.encode({:ok=>true, :filename=>filename})
      end
    
      
      
    rescue Exception=>e
      
      render :json=>{:ok=>false, :error_messages=>e.message}
      
    end

  end

  def image
   
    @allow_extensions = ["jpg","jpeg","gif","png"]
    index
    
  end
  
  def any_file
    
    @allow_extensions = ["zip","pdf","txt","doc","xls","rar","jpg","jpeg","gif","png"]
    index
    
  end
  
  
  
end
