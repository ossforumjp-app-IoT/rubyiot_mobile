class Controller
  HTTP = 'http://'
  CONTROLLER_URL = '/api/controller?gateway_id='
  
  # retriving data via api
  def self.retrieve_data(gateway_id, block)
    @gateway_id = gateway_id
    @block = block

    url = HTTP + $settings.server_address + CONTROLLER_URL + @gateway_id.to_s
    BW::HTTP.get(url, {cookie: $loginSession}) do |response|
      data = []
      if response.ok?
        json = BW::JSON.parse(response.body.to_str)
        json.each do |item|
          controller_id = item[0]
          data << {
            :id => controller_id,
            :name => json[controller_id]['name'],
            :value => json[controller_id]['value'],
            :device_id => json[controller_id]['device_id'],
            :value_range => json[controller_id]['value_range'],
          }
        end
        @block.call(data)
      else
        @block.call(data)
      end
    end
  end
end
