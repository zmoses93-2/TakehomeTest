class Device
  def initialize(uuid)
    @uuid = uuid
  end

  def readings_key
    "#{@uuid}::readings"
  end

  def latest_timestamp
    latest_reading = $redis.zrevrange(readings_key, 0, 0).first
    return nil unless latest_reading

    JSON.parse(latest_reading)["timestamp"]
  end

  def cumulative_count
    all_readings = $redis.zrange(readings_key, 0, -1)
    return nil unless all_readings

    all_readings.map { |reading| JSON.parse(reading)["count"] }.sum
  end
end
