require 'spec_helper'

describe RGeoServer::Coverage do
  it 'responds to API' do
    %w(
        abstract
        catalog
        coverage_store
        enabled
        keywords
        metadata
        metadata_links
        name
        route
        save
        title
        workspace
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
