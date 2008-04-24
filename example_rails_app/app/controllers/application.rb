# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  # userstamp filter
  # NOTE: since this sets @current_user, you'll want to use prepend_before_filter
  #       for login_required if you want HTTP authentication to work properly
  before_filter do |c|
    User.current_user = c.current_user == :false ? nil : c.current_user
  end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_example_rails_app_session_id'
end
