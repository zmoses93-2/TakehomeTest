require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:all) do
    $redis.flushdb
    [ { timestamp: "2021-09-29T16:08:15+01:00", count: 2 }, { timestamp: "2021-09-29T16:09:15+01:00", count: 15 } ].each do |reading|
      Reading.new(reading).save("test")
    end
  end

  let(:device) { Device.new("test") }

  describe "#readings_key" do
    it "should return a valid key" do
      expect(device.readings_key).to eq("test::readings")
    end
  end

  describe "#latest_timestamp" do
    it "returns the latest timestamp" do
      expect(device.latest_timestamp).to eq("2021-09-29T16:09:15+01:00")
    end
  end

  describe "#cumulative_count" do
    it "returns the cumulative count" do
      expect(device.cumulative_count).to eq(17)
    end
  end
end
