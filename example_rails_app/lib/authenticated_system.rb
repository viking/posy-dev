module AuthenticatedSystem
  DEFAULT_ACTION_PERMISSIONS = HashWithIndifferentAccess.new({
    'r' => %w{index show},
    'w' => %w{new create update destroy},
    'b' => %w{edit},
    't' => %w{edit update destroy}
  })

  # Actions that are affected by resource permissions.
  DEFAULT_RESOURCE_ACTIONS = %w{show edit update destroy}

  # Actions that are affected when a permission is sticky.
  DEFAULT_STICKY_ACTIONS   = %w{edit update destroy}

  module ClassMethods
    # You can use this method to either get or set the action_permissions inheritable
    # attribute.  You'll probably want to use chmod instead of setting this manually.
    #
    def action_permissions(hsh = nil)
      return read_inheritable_attribute(:action_permissions)  if hsh.nil?
      write_inheritable_hash(:action_permissions, hsh)
    end

    # You can use this method to get or add additional actions which should look for resource
    # permissions prior to looking for controller permissions.  The default actions are:
    # show, edit, update, destroy.
    #
    def resource_actions(*actions)
      return read_inheritable_attribute(:resource_actions)    if actions.empty?
      write_inheritable_array(:resource_actions, actions.collect { |a| a.to_s })
    end

    # Use this method to remove actions from the list of actions that should look for
    # resource permissions.
    #
    def remove_resource_actions(*actions)
      write_inheritable_attribute(:resource_actions, read_inheritable_attribute(:resource_actions) - actions.collect { |a| a.to_s })
    end

    # You can use this method to get or add additional actions that are affected by sticky
    # permissions.  The default actions are: edit, update, destroy.
    #
    # NOTE: It doesn't make sense to have an action in sticky_actions that also isn't in
    #       resource_actions, because access will always be denied (since authorized? will
    #       check for current_resource, which would be nil for a non-resource action).
    #
    def sticky_actions(*actions)
      return read_inheritable_attribute(:sticky_actions)    if actions.empty?
      write_inheritable_array(:sticky_actions, actions.collect { |a| a.to_s })
    end

    # Use this method to remove actions from the list of actions that are affected by
    # sticky permissions.
    #
    def remove_sticky_actions(*actions)
      write_inheritable_attribute(:sticky_actions, read_inheritable_attribute(:sticky_actions) - actions.collect { |a| a.to_s })
    end

    # Use this to get or set the model name that I should use to look for resource permissions.
    # By default, this is the singular of the controller name.
    #
    def resource_model_name(name = nil)
      # NOTE: using instance variable instead of class variable here
      if name
        @resource_model_name = name.to_s.classify
      end
      @resource_model_name ||= controller_name.singularize.classify
    end

    # Use this method to set what permissions are needed to perform what actions.
    # You can also override default permissions.
    #
    # NOTE: This isn't exactly like its unix counterpart.  Since an action can
    #       require that a user have both read AND write privileges to access
    #       it, "+rw" is different than "+b" ('b' is the letter used for
    #       both read and write access).  So if you wanted to make an action
    #       only accessible by read AND write users, do "-rw+b" (or just "b").
    #       If you don't have a '+' or '-', the permission is just set to whatever
    #       you specify.
    #
    # Examples:
    #   chmod "+r", :foo
    #   chmod "+rw", :bar, :baz
    #   chmod "-r", :index
    #   chmod "b", :update
    #
    def chmod(permission, *actions)
      # parse permission string
      perms = { 'add' => [], 'del' => [], 'set' => [] }
      mode  = "set" 
      permission.split(//).each do |p|
        case p
        when '+'
          mode = "add"
        when '-'
          mode = "del"
        when 'r', 'w', 'b'
          perms[mode] << p
        else
          raise "bad permission string: '#{permission}'"
        end
      end

      # NOTE: if a "set" exists, the others are ignored
      unless perms["set"].empty?
        perms["add"] = []
        perms["del"] = []
        %w{r w b}.each do |x|
          if perms["set"].include?(x)
            perms["add"] << x
          else
            perms["del"] << x
          end
        end
      end

      hsh = action_permissions.dup
      actions = actions.collect { |a| a.to_s }
      perms["add"].each do |p|
        hsh[p] |= actions
      end
      perms["del"].each do |p|
        hsh[p] -= actions
      end
      write_inheritable_hash(:action_permissions, hsh)
    end
  end

  def action_permissions(hsh = nil)
    self.class.action_permissions(hsh)
  end

  def resource_actions(*actions)
    self.class.resource_actions(*actions)
  end

  def remove_resource_actions(*actions)
    self.class.remove_resource_actions(*actions)
  end

  def sticky_actions(*actions)
    self.class.sticky_actions(*actions)
  end

  def remove_sticky_actions(*actions)
    self.class.remove_sticky_actions(*actions)
  end

  def resource_model_name(name = nil)
    self.class.resource_model_name(name)
  end

  # Accesses the current user from the session.
  # NOTE: this is public so that the userstamp filter can access it
  def current_user
    @current_user ||= (session[:user] && User.find_by_id(session[:user])) || :false
  end

  protected
    def current_resource
      unless defined? @current_resource
        unless params[:id]
          @current_resource = nil
          return @current_resource
        end
        
        begin
          model = resource_model_name.constantize
          @current_resource = model.find_by_id(params[:id]) # returns nil if not found
        rescue NameError => boom
          logger.error boom
          raise NameError, "resource_model_name is bad; please use the resource_model_name method to set the correct model name"
        end
      end
      @current_resource
    end

    # This will grab the associated permission for the selected action.  If params[:id] exists,
    # it will try to grab the permission for the associated resource FIRST, and if that doesn't
    # exist it will try to get the permission for the associated controller.
    #
    # You can use the following methods to tweak how this works:
    #   resource_actions:        use to add additional actions that use resources
    #   remove_resource_actions: use to remove actions that use resources
    #   resource_model_name:     use to change the model name of the resource
    #   
    def current_permission
      unless defined? @current_permission 
        if current_user == :false
          @current_permission = nil
          return @current_permission
        end
        perms = current_user.permissions

        # grab the current resource permission
        if resource_actions.include?(action_name) and !current_resource.nil?
          @current_permission = perms.detect { |p| p.resource == current_resource } 
        end
        @current_permission ||= perms.detect { |p| p.controller == controller_name }
      end
      @current_permission
    end

    def user_can_read?
      current_permission ? current_permission.can_read : false
    end

    def user_can_write?
      current_permission ? current_permission.can_write : false
    end

    def user_can_read_and_write?
      current_permission ? current_permission.can_read && current_permission.can_write : false
    end

    def permission_is_sticky?
      current_permission ? current_permission.is_sticky : false
    end

    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      current_user != :false
    end
    
    # Store the given user in the session.
    def current_user=(new_user)
      session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
      @current_user = new_user
    end
    
    # Check if the user is authorized.  You can specify one-time permissions via:
    #     flash[:allow] = true
    #
    # See the DEFAULT_ACTION_PERMISSIONS constant for default behavior.
    #
    # About sticky permissions:
    #   If preliminary access is granted for the user, sticky_actions is checked to see
    #   whether or not the requested action is affected by sticky permissions.  If it is,
    #   then current_permission is first checked, and then current_resource is tested to
    #   see if the user is the creator.
    #
    #   See the DEFAULT_STICKY_ACTIONS constant for the default list of actions that are
    #   affected by stickiness.
    #
    # NOTE: controllers with additional actions should specify what permission is required
    #       to access those actions by using =chmod=; actions not specified are denied by default.
    #
    # NOTE: this method gets run AFTER logged_in?, so assume the user is logged in
    def authorized?
      return true   if controller_name == 'sessions'
      return true   if current_user.admin? or flash[:allow]
      return false  unless current_permission

      ap     = action_permissions
      bools  = []
      bools << user_can_read?             if ap['r'].include?(action_name)
      bools << user_can_write?            if ap['w'].include?(action_name)
      bools << user_can_read_and_write?   if ap['b'].include?(action_name)
      if bools.any?
        # handle sticky permissions
        if sticky_actions.include?(action_name) and permission_is_sticky?
          # make sure the user is the owner
          current_resource ? current_resource.created_by == current_user.id : false
        else
          true
        end
      else
        false
      end
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      unless @current_user
        username, passwd = get_auth_data
        self.current_user = User.authenticate(username, passwd) || :false if username && passwd
      end
      logged_in? && authorized? ? true : access_denied
    end
    
    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |accepts|
        accepts.html do
          if logged_in?
            render :template => 'errors/denied', :status => :unauthorized
          else
            store_location
            redirect_to :controller => 'sessions', :action => 'new'
          end
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Couldn't authenticate you", :status => :unauthorized
        end
      end
      false
    end  
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      session[:return_to] ? redirect_to_url(session[:return_to]) : redirect_to(default)
      session[:return_to] = nil
    end
    
    # Inclusion hook to make a few methods available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?, :current_permission,
                :user_can_read?, :user_can_write?, :user_can_read_and_write?

      # inheritable variables for authentication
      base.extend(ClassMethods)

      # default action_permissions hash
      unless base.inheritable_attributes[:action_permissions]
        base.write_inheritable_attribute(:action_permissions, DEFAULT_ACTION_PERMISSIONS.dup)
      end

      # default resource_actions array
      unless base.inheritable_attributes[:resource_actions]
        base.write_inheritable_attribute(:resource_actions, DEFAULT_RESOURCE_ACTIONS.dup)
      end

      # default sticky_actions array
      unless base.inheritable_attributes[:sticky_actions]
        base.write_inheritable_attribute(:sticky_actions, DEFAULT_STICKY_ACTIONS.dup)
      end
    end

  private
    @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
    end
end
