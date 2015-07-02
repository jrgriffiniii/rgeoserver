require 'spec_helper'

describe RGeoServer::FeatureType do
  it 'responds to API' do
    %w(
        abstract
        catalog
        data_store
        enabled
        keywords
        latlon_bounds
        metadata
        metadata_links
        name
        native_bounds
        native_name
        projection_policy
        route
        save
        title
        to_mimetype
        valid_native_bounds?
        valid_latlon_bounds?
        workspace
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
