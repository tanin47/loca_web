class LoginController < ApplicationController 


  
  def index
    
    member = Member.create_or_get(params[:facebook_id])

    changed_attributes = {}
    changed_attributes[:name] = params[:name] if member.name != params[:name]
    changed_attributes[:access_token] = params[:access_token] if member.name != params[:access_token]
    
    member.update_attributes(changed_attributes) if changed_attributes.length > 0
    
    render :json => {:ok => true, :member => member.to_hash }
    
  end

end
