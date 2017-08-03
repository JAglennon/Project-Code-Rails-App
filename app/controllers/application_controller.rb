class ApplicationController < ActionController::Base
	 include ActionController::Live
protect_from_forgery with: :exception

# API POST REGUEST ALLOW CROSS DOMAIN
  before_filter :cor
  def cor
    headers["Access-Control-Allow-Origin"]  = "*"
    headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
    headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")
    head(:ok) if request.request_method == "OPTIONS"
  end

  def index
    response.headers['Content-Type'] = 'text/event-stream'
  end
end
