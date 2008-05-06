require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/show.rhtml" do
  include PeopleHelper
  
  before(:each) do
    @person = mock_model(Person)
    @person.stub!(:name).and_return("MyString")

    assigns[:person] = @person
  end

  it "should render attributes in <p>" do
    render "/people/show.rhtml"
    response.should have_text(/MyString/)
  end
end

