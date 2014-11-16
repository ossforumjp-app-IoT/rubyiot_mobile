class Monitor
  # rakuten item search api (to set applicationId value)
  HTTP = 'http://'
  MONITOR_URL = '/api/monitor'

  # retriving data via api
  def self.retrieve_data(block, sensor_id)
    url = HTTP + $settings.server_address + MONITOR_URL + "?sensor_id=#{sensor_id}"
    BW::HTTP.get(url) do |response|
      if response.ok?
        data = []
        #p "response=#{response}"
        json = BW::JSON.parse(response.body.to_str)
        data << {
          :id => sensor_id,
          :min => json['min'],
          :max => json['max'],
        }
        block.call(data)
      else
        #App.alert(response.error_message)
        App.alert("監視値の取得に失敗しました")
      end
    end
  end

  def self.post_data(block, sensor_id, min, max)
    url = HTTP + $settings.server_address + MONITOR_URL + "?sensor_id=#{sensor_id}"

payload = <<EOS
  { "#{sensor_id}": { "min": "#{min}", "max": "#{max}" } }
EOS

#p "payload=#{payload}"
    BW::HTTP.post(url, payload: payload) do |response|
      if response.ok?
        p "OK"
      else
        p "NG"
      end
      block.call
    end
  end
end
