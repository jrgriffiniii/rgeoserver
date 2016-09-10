require 'spec_helper'

describe RGeoServer::CoverageStore do
  it 'responds to API' do
    %w(
        catalog
        coverages
        data_type
        description
        enabled
        name
        route
        save
        workspace
        upload
        url
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
