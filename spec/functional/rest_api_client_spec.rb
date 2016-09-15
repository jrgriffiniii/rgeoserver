require 'spec_helper'
require 'awesome_print'

describe RGeoServer::RestApiClient do
  subject { RGeoServer::Catalog.new }

  describe "REST API sequences" do

    describe "basic" do
      it "main" do
        RGeoServer::RestApiClient::URI_SEQUENCES.each do |seq|
          if not [[:about], [:layers, :styles]].include? seq
            subject.url_for(Hash[seq.map {|k| [k, 'abc']}]).is_a?(String).should == true
          end
        end
      end

      it "exceptions" do
        expect {
          subject.url_for(:abc => "abc")
        }.to raise_error RGeoServer::GeoServerArgumentError
      end

      it "formats" do
        subject.url_for(:workspaces => nil).should == "workspaces.xml"
        subject.url_for('workspaces', {:format => :xml}).should == "workspaces.xml"
        subject.url_for('workspaces', {:format => :html}).should == "workspaces.html"
        subject.url_for('workspaces', {:format => :json}).should == "workspaces.json"
      end
    end


    describe "workspaces" do
      it "main" do
        subject.url_for(:workspaces => nil).should == "workspaces.xml"
        subject.url_for(:workspaces => "druid").should == "workspaces/druid.xml"
        subject.url_for(:workspaces => "default").should == "workspaces/default.xml"
      end
    end

    describe "datastores" do
      it "main" do
        what = {:workspaces => "druid", :datastores => nil}
        base = "workspaces/druid/datastores"
        subject.url_for(what).should == base + ".xml"
        what[:datastores] = "abc"
        subject.url_for(what).should == base + "/abc.xml"
        subject.url_for(what.merge({:file => nil})).should == base + "/abc/file.xml"
        subject.url_for(what.merge({:external => nil})).should == base + "/abc/external.xml"
        subject.url_for(what.merge({:url => nil})).should == base + "/abc/url.xml"
      end

      it "exceptions" do
        expect {
          subject.url_for(:datastores => nil)
        }.to raise_error RGeoServer::GeoServerArgumentError
        expect {
          subject.url_for(:datastores => "abc")
        }.to raise_error RGeoServer::GeoServerArgumentError
      end
    end

    describe "featuretypes" do
      it "main" do
        what = {:workspaces => "druid", :datastores => "abc", :featuretypes => nil}
        base = "workspaces/druid/datastores/abc/featuretypes"
        subject.url_for(what).should == base + ".xml"
        what[:featuretypes] = "xyz"
        subject.url_for(what).should == base + "/xyz.xml"
      end
    end

    describe "layers" do
      it "main" do
        subject.url_for(:layers => nil).should == "layers.xml"
        subject.url_for(:layers => "abc").should == "layers/abc.xml"
        subject.url_for(:layers => "abc", :styles => nil).should == "layers/abc/styles.xml"
      end
    end

    describe "layergroups" do
      it "main" do
        base = "layergroups"
        subject.url_for({:layergroups => nil}).should == base + ".xml"
        subject.url_for({:layergroups => "abc"}).should == base + "/abc.xml"
      end

      it "workspace" do
        what = {:workspaces => "druid", :layergroups => nil}
        base = "workspaces/druid/layergroups"
        subject.url_for(what).should == base + ".xml"
        what[:layergroups] = "abc"
        subject.url_for(what).should == base + "/abc.xml"
      end
    end

    describe "namespaces" do
      it "main" do
        subject.url_for(:namespaces => nil).should == "namespaces.xml"
        subject.url_for(:namespaces => "abc").should == "namespaces/abc.xml"
        subject.url_for(:namespaces => "default").should == "namespaces/default.xml"
      end

    end

    describe "coverages" do
      it "main" do
        what = {:workspaces => "druid", :coveragestores => "abc", :coverages => nil}
        base = "workspaces/druid/coveragestores/abc/coverages"
        subject.url_for(what).should == base + ".xml"
        what[:coverages] = "xyz"
        subject.url_for(what).should == base + "/xyz.xml"
      end

      it "exceptions" do
        expect {
          subject.url_for(:coverages => nil)
        }.to raise_error RGeoServer::GeoServerArgumentError
      end
    end

    describe "about" do
      it "main" do
        subject.url_for(:about => :version).should == "about/version.xml"
        subject.url_for(:about => :manifest).should == "about/manifest.xml"
      end
    end
  end

end
