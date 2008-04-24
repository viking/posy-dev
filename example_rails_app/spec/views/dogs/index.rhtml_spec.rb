require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dogs/index.rhtml" do
  include DogsHelper
  
  before(:each) do
    dog_98 = mock_model(Dog)
    dog_98.should_receive(:name).and_return("MyString")
    dog_99 = mock_model(Dog)
    dog_99.should_receive(:name).and_return("MyString")

    assigns[:dogs] = [dog_98, dog_99]
  end

  it "should render list of dogs" do
    render "/dogs/index.rhtml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

