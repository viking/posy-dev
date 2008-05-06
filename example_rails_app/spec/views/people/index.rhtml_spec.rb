require File.dirname(__FILE__) + '/../../spec_helper'

describe "/people/index.rhtml" do
  include PeopleHelper
  
  before(:each) do
    person_98 = mock_model(Person)
    person_98.should_receive(:name).and_return("MyString")
    person_99 = mock_model(Person)
    person_99.should_receive(:name).and_return("MyString")

    assigns[:people] = [person_98, person_99]
  end

  it "should render list of people" do
    render "/people/index.rhtml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

