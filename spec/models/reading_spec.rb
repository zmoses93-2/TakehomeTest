require 'rails_helper'

RSpec.describe Reading, type: :model do
  before(:each) do
    $redis.flushdb
  end

  let(:reading) { Reading.new({ "timestamp": "2021-09-29T16:09:15+01:00", "count": 15 }) }

  describe '#sort_value' do
    it "returns a valid sort value" do
      expect(reading.sort_value).to eq(1632928155)
    end
  end

  describe '#save' do
    it "saves to Redis" do
      reading.save("test")
      expect($redis.zrange("test::readings", 0, -1)).to eq([ "{\"timestamp\":\"2021-09-29T16:09:15+01:00\",\"count\":15}" ])
    end
  end

  describe "#readings_key" do
    it "returns a valid readings key" do
      expect(reading.readings_key("test")).to eq("test::readings")
    end
  end
end
