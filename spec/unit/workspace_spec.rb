require 'spec_helper'

describe RGeoServer::Workspace do
  it 'responds to API' do
    %w(
        catalog
        coverage_stores
        data_stores
        enabled
        name
        route
        save
        wms_stores
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
