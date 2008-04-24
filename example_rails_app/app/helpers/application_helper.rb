# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def resource_name(resource)
    resource.send(Posy.name_method_for(resource.class))
  end

  def resource_link(resource)
    case resource
    when String
      h(resource)
    when ActiveRecord::Base
      link_to("#{resource.send(Posy.name_method_for(resource.class))} (#{resource.class})",
              :controller => resource.class.to_s.tableize, :action => 'show', :id => resource.id)
    else
      resource
    end
  end

end
