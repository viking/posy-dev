require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dogs/edit.rhtml" do
  include DogsHelper
  
  before do
    @dog = mock_model(Dog)
    @dog.stub!(:name).and_return("MyString")
    assigns[:dog] = @dog
  end

  it "should render edit form" do
    render "/dogs/edit.rhtml"
    
    response.should have_tag("form[action=#{dog_path(@dog)}][method=post]") do
      with_tag('input#dog_name[name=?]', "dog[name]")
    end
  end
end


