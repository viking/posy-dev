require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dogs/show.rhtml" do
  include DogsHelper
  
  before(:each) do
    @dog = mock_model(Dog)
    @dog.stub!(:name).and_return("MyString")

    assigns[:dog] = @dog
  end

  it "should render attributes in <p>" do
    render "/dogs/show.rhtml"
    response.should have_text(/MyString/)
  end
end

