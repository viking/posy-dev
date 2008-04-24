require File.dirname(__FILE__) + '/../../spec_helper'

describe "/cats/index.rhtml" do
  include CatsHelper
  
  before(:each) do
    cat_98 = mock_model(Cat)
    cat_98.should_receive(:name).and_return("MyString")
    cat_99 = mock_model(Cat)
    cat_99.should_receive(:name).and_return("MyString")

    assigns[:cats] = [cat_98, cat_99]
  end

  it "should render list of cats" do
    render "/cats/index.rhtml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

