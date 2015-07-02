require 'spec_helper'

describe RGeoServer do
  it 'responds to API' do
    %w(
        catalog
      ).map(&:to_sym).each do |m|
      expect {
        fail "API is missing: #{m}" unless described_class.respond_to?(m)
      }.not_to raise_error
    end
  end
end

describe RGeoServer::RGeoServerError do
  it 'responds to API' do 
    expect(described_class).to be_truthy
  end
end

describe RGeoServer::GeoServerInvalidRequest do
  it 'responds to API' do 
    expect(described_class).to be_truthy
  end
end

describe RGeoServer::GeoServerArgumentError do
  it 'responds to API' do 
    expect(described_class).to be_truthy
  end
end