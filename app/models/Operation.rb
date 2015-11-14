class Operation
  HTTP = 'http://'
  OPERATION_URL = '/api/operation'
  OPERATION_STATUS_URL = '/api/operation_status'

  # retriving data via api
  def self.retrieve_data(block, operation_id)
    url = HTTP + $settings.server_address + OPERATION_STATUS_URL + "?operation_id=#{operation_id}"
    BW::HTTP.get(url, {cookie: $loginSession}) do |response|
      if response.ok?
        data = []
        #p "response=#{response}"
        json = BW::JSON.parse(response.body.to_str)
        data << {
          :operation_id => operation_id,
          :value => json['value'],
          :status => json['status'],
        }
        block.call(data)
      else
        block.call(nil)
      end
    end
  end

  def self.post_data(block, controller_id, value)
    url = HTTP + $settings.server_address + OPERATION_URL
    payload = {"#{controller_id}" => "#{value}"}
    BW::HTTP.post(url, payload: BW::JSON.generate(payload), cookie: $loginSession) do |response|
      if response.ok?
        data = []
        json = BW::JSON.parse(response.body.to_str)
        data << {
          :operation_id => json['operation_id'],
          :controller_id => controller_id,
        }
        block.call(data)
      else
        block.call(nil)
      end
    end
  end
end
