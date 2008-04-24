require File.dirname(__FILE__) + '/../../spec_helper'

describe "/cats/new.rhtml" do
  include CatsHelper
  
  before(:each) do
    @cat = mock_model(Cat)
    @cat.stub!(:new_record?).and_return(true)
    @cat.stub!(:name).and_return("MyString")
    assigns[:cat] = @cat
  end

  it "should render new form" do
    render "/cats/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", cats_path) do
      with_tag("input#cat_name[name=?]", "cat[name]")
    end
  end
end


