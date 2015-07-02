require 'spec_helper'

describe RGeoServer::Layer do
  it 'responds to API' do
    %w(
        alternate_styles
        attribution
        catalog
        default_style
        enabled
        layer_type
        metadata
        name
        path
        queryable
        route
        save
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.public_instance_methods.include?(m)
      }.not_to raise_error
    end
  end
end
