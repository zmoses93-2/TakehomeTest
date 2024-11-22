Reading = Struct.new(:timestamp, :count, keyword_init: true) do
  def sort_value
    Time.parse(timestamp).to_i
  end

  def save(uuid)
    $redis.zadd(readings_key(uuid), sort_value, self.to_json)
  end

  def readings_key(uuid)
    Device.new(uuid).readings_key
  end
end
