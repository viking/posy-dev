require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dogs/new.rhtml" do
  include DogsHelper
  
  before(:each) do
    @dog = mock_model(Dog)
    @dog.stub!(:new_record?).and_return(true)
    @dog.stub!(:name).and_return("MyString")
    assigns[:dog] = @dog
  end

  it "should render new form" do
    render "/dogs/new.rhtml"
    
    response.should have_tag("form[action=?][method=post]", dogs_path) do
      with_tag("input#dog_name[name=?]", "dog[name]")
    end
  end
end


