require 'spec_helper'

describe RGeoServer::Style do
  it 'responds to API' do
    %w(
        catalog
        enabled
        filename 
        layers 
        name
        route
        save
        sld_version
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
