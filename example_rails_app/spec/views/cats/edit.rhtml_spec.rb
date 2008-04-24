require File.dirname(__FILE__) + '/../../spec_helper'

describe "/cats/edit.rhtml" do
  include CatsHelper
  
  before do
    @cat = mock_model(Cat)
    @cat.stub!(:name).and_return("MyString")
    assigns[:cat] = @cat
  end

  it "should render edit form" do
    render "/cats/edit.rhtml"
    
    response.should have_tag("form[action=#{cat_path(@cat)}][method=post]") do
      with_tag('input#cat_name[name=?]', "cat[name]")
    end
  end
end


