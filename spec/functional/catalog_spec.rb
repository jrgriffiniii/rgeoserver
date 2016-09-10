require 'spec_helper'
require 'awesome_print'

describe RGeoServer::Catalog do
  describe "Init" do
    it "catalog" do
      subject.config.include?(:url).should == true
      subject.headers.include?(:content_type).should == true
    end
  end

  describe "#url_for" do
    it "simple" do
      subject.respond_to?('url_for').should == true
    end
  end

  describe "Workspace" do
    before(:each) do
      @w = subject.get_workspace 'druid'
      @w_default = subject.get_default_workspace
      ap({ :catalog => subject, :workspace_druid => @w, :workspace_default => @w_default }) if $DEBUG
    end

    it "workspace" do
      @w.name.should == 'druid'
      @w_default.name.should == @w.name
    end

    it "#get_workspaces as array" do
      @w_all = subject.get_workspaces
      @w_all.size.should > 0
    end

    it "#get_workspaces as block" do
      subject.get_workspaces do |w|
        w.name.length.should > 0
      end
    end
  end

  describe "Layers" do
    it "#each_layer" do
      subject.each_layer.to_a.size.should > 0
      subject.each_layer do |l|
        # ap l.resource
      end
    end
  end

  describe "DataStore" do
    it "#get_data_stores" do
      subject.get_data_stores.size.should > 0
    end
  end

  describe "CoverageStore" do
    it "#get_coverage_stores" do
      subject.get_coverage_stores.size.should > 0
    end
  end

  describe "WMSStore" do
    it "#get_wms_stores" do
      subject.get_wms_stores.size.should > 0
    end
  end

end
