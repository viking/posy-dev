module MembershipsHelper
  def link_to_index(name, html_options = nil, *parameters_for_method_reference)
    if @user
      link_to(name, user_memberships_path(@user), html_options, *parameters_for_method_reference)
    elsif @group
      link_to(name, group_memberships_path(@group), html_options, *parameters_for_method_reference)
    else
      link_to(name, memberships_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_new(name, html_options = nil, *parameters_for_method_reference)
    if @user
      link_to(name, new_user_membership_path(@user), html_options, *parameters_for_method_reference)
    elsif @group
      link_to(name, new_group_membership_path(@group), html_options, *parameters_for_method_reference)
    else
      link_to(name, new_membership_path, html_options, *parameters_for_method_reference)
    end
  end

  def link_to_show(name, membership, html_options = nil, *parameters_for_method_reference)
    if @user
      link_to(name, user_membership_path(@user, membership), html_options, *parameters_for_method_reference)
    elsif @group
      link_to(name, group_membership_path(@group, membership), html_options, *parameters_for_method_reference)
    else
      link_to(name, membership_path(membership), html_options, *parameters_for_method_reference)
    end
  end

  def link_to_destroy(name, membership, html_options = {}, *parameters_for_method_reference)
    html_options = html_options.merge(:method => :delete)

    if @user
      link_to(name, user_membership_path(@user, membership), html_options, *parameters_for_method_reference)
    elsif @group
      link_to(name, group_membership_path(@group, membership), html_options, *parameters_for_method_reference)
    else
      link_to(name, membership_path(membership), html_options, *parameters_for_method_reference)
    end
  end

  def url_for_create
    if @user
      user_memberships_path(@user)
    elsif @group
      group_memberships_path(@group)
    else
      memberships_path
    end
  end
end
