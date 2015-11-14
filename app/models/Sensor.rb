class Sensor
  HTTP = 'http://'
  SENSOR_URL = '/api/sensor?gateway_id='

  # retriving data via api
  def self.retrieve_data(gateway_id, block)
    @gateway_id = gateway_id
    @block = block
    
    retrieve_data_func = lambda do |login|
      if login == false
        @block.call(nil)
        return
      end
      
      url = HTTP + $settings.server_address + SENSOR_URL + @gateway_id.to_s
      BW::HTTP.get(url, {cookie: $loginSession}) do |response|
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
          @block.call(data)
        else
          @block.call(nil)
        end
      end
    end # lambda

    ServerLogin.login(retrieve_data_func)
  end
end
