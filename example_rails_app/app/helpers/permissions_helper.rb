module PermissionsHelper
  def link_to_index(name, html_options = nil, *parameters_for_method_reference)
    if @group
      link_to(name, group_permissions_path(@group), html_options, *parameters_for_method_reference)
    else
      link_to(name, permissions_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_new(name, html_options = nil, *parameters_for_method_reference)
    if @group
      link_to(name, new_group_permission_path(@group), html_options, *parameters_for_method_reference)
    else
      link_to(name, new_permission_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_show(name, permission, html_options = nil, *parameters_for_method_reference)
    if @group
      link_to(name, group_permission_path(@group, permission), html_options, *parameters_for_method_reference)
    else
      link_to(name, permission_path(permission), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_edit(name, permission, html_options = nil, *parameters_for_method_reference)
    if @group
      link_to(name, edit_group_permission_path(@group, permission), html_options, *parameters_for_method_reference)
    else
      link_to(name, edit_permission_path(permission), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_destroy(name, permission, html_options = {}, *parameters_for_method_reference)
    html_options = html_options.merge(:method => :delete)

    if @group
      link_to(name, group_permission_path(@group, permission), html_options, *parameters_for_method_reference)
    else
      link_to(name, permission_path(permission), html_options, *parameters_for_method_reference)
    end
  end

  def url_for_create
    if @group
      group_permissions_path(@group)
    else
      permissions_path
    end
  end

  def url_for_update(permission)
    if @group
      group_permission_path(@group, permission)
    else
      permission_path(permission)
    end
  end
end
