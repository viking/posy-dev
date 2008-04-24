require File.dirname(__FILE__) + '/../../spec_helper'

describe "/cats/show.rhtml" do
  include CatsHelper
  
  before(:each) do
    @cat = mock_model(Cat)
    @cat.stub!(:name).and_return("MyString")

    assigns[:cat] = @cat
  end

  it "should render attributes in <p>" do
    render "/cats/show.rhtml"
    response.should have_text(/MyString/)
  end
end

