require 'spec_helper'

describe RGeoServer::DataStore do
  it 'responds to API' do
    %w(
        catalog
        connection_parameters
        data_type
        description
        enabled
        featuretypes
        name
        route
        save
        upload
        upload_external
        upload_file
        upload_url
        workspace
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
