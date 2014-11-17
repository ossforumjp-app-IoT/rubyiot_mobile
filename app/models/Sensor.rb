class Sensor
  HTTP = 'http://'
  SENSOR_URL = '/api/sensor?gateway_id=1'

  # retriving data via api
  def self.retrieve_data(block)
    url = HTTP + $settings.server_address + SENSOR_URL
    BW::HTTP.get(url) do |response|
      if response.ok?
        data = []
        json = BW::JSON.parse(response.body.to_str)
        json.each do |item|
          sensor_id = item[0]
          data << {
            :id => sensor_id,
            :name => json[sensor_id]['name'],
            :device_id => json[sensor_id]['device_id'],
            :value => json[sensor_id]['value'],
            :alert => json[sensor_id]['alert'],
            :datetime => json[sensor_id]['datetime'],
            :unit => json[sensor_id]['unit'],
          }
        end
        block.call(data)
      else
        block.call(nil)
      end
    end
  end
end
