require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/new.rhtml" do
  include PeopleHelper
  
  before(:each) do
    @person = mock_model(Person)
    @person.stub!(:new_record?).and_return(true)
    @person.stub!(:name).and_return("MyString")
    assigns[:person] = @person
  end

  it "should render new form" do
    render "/people/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", people_path) do
      with_tag("input#person_name[name=?]", "person[name]")
    end
  end
end


