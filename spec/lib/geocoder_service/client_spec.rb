# frozen_string_literal: true

RSpec.describe GeocoderService::Client, type: :client do
  subject(:client) { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.get('') { [status, headers, body.to_json] }
  end

  describe '# (valid param)' do
    let(:coordinates) { { 'lat' => 1.1, 'lon' => 2.2 } }
    let(:body) { { 'data' => coordinates } }

    it 'returns city coordinates' do
      expect(client.get_coordinates('valid.param')).to eq(coordinates)
    end
  end

  describe '# (invalid param)' do
    let(:status) { 422 }

    it 'returns a nil value' do
      expect(client.get_coordinates('invalid.param')).to be_empty
    end
  end

  describe '# (nil param)' do
    let(:status) { 422 }

    it 'returns a nil value' do
      expect(client.get_coordinates(nil)).to be_empty
    end
  end
end
