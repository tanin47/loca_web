class ApplicationController < ActionController::Base
  #protect_from_forgery
  include ::SslRequirement
  ssl_allowed :all


end
