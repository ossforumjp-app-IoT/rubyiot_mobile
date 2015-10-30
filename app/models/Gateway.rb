class Gateway
  HTTP = 'http://'
  SENSOR_URL = '/api/gateway'

  # retriving data via api
  def self.retrieve_data(block)
    @block = block
    
    retrieve_data_func = lambda do |login|
      if login == false
        @block.call(nil)
      end
      
      url = HTTP + $settings.server_address + SENSOR_URL
      BW::HTTP.get(url, {cookie: $loginSession}) do |response|
        if response.ok?
          data = []
          json = BW::JSON.parse(response.body.to_str)
          json.each do |item|
            gateway_id = item[0]
            data << {
              :id => gateway_id,
              :hardware_uid => json[gateway_id]['hardware_uid'],
              :name => json[gateway_id]['name'],
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
