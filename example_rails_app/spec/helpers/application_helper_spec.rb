require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  include ApplicationHelper 
  
  describe "#resource_name" do
    before(:each) do
      @pocky = Pocky.new
      Posy.stub!(:name_method_for).and_return('name')
      @pocky.stub!(:name).and_return("teh p0cky")
    end

    it "should call Posy.name_method_for" do
      Posy.should_receive(:name_method_for).and_return('name')
      resource_name(@pocky)
    end

    it "should call Pocky#name" do
      @pocky.should_receive(:name).and_return("teh p0cky")
      resource_name(@pocky)
    end

    it "should return 'teh p0cky'" do
      resource_name(@pocky).should == "teh p0cky"
    end
  end

  describe "#resource_link" do

    it "should return escaped string when argument is a String" do
      resource_link("<weee!>").should == h("<weee!>")
    end

    it "should return link to resource when argument is an ActiveRecord" do
      Posy.stub!(:name_method_for).and_return('name')
      pocky = Pocky.new
      pocky.stub!(:name).and_return("teh p0cky")

      resource_link(pocky).should == link_to("teh p0cky (Pocky)", :controller => "pockies", :action => "show", :id => pocky.id)
    end

    it "should return argument if not a String or ActiveRecord" do
      resource_link(1337).should == 1337
    end
  end
end
