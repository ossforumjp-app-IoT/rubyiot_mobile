class Sensor
  HTTP = 'http://'
  SENSOR_URL = '/api/sensor?gateway_id=1'

  # retriving data via api
  def self.retrieve_data(block)
# debug mode begin
=begin
    data = []
    sensor_id = "1"
    sensor_name = "TEST SENSOR"
    device_id = "1"
    data_unit = "degree"
    property_name = "ppp"
    value = Time.now.sec.to_s
    #value = "23"
    datetime = "2014-10-10+12:00:00"
    alert = "0"

    data << {
      :id => sensor_id,
      :name => sensor_name,
      :value => value,
      :device_id => device_id,
      :data_unit => data_unit,
      :datetime => datetime,
      :alert => alert,
      :property_name => property_name,
    }
    #p "data=#{data}"
    block.call(data)
#debug mode end
=end
    url = HTTP + $settings.server_address + SENSOR_URL
    BW::HTTP.get(url) do |response|
      if response.ok?
        data = []
        json = BW::JSON.parse(response.body.to_str)
        json.each do |item|
          sensor_id = item[0]
          if (json[sensor_id]['value'] == "10")
            a = "1"
          else
            a = "0"
          end
          data << {
            :id => sensor_id,
            :name => json[sensor_id]['name'],
            :device_id => json[sensor_id]['device_id'],
            :value => json[sensor_id]['value'],
            :alert => a,
#            :alert => json[sensor_id]['alert'],
            :datetime => json[sensor_id]['datetime'],
            #:property_name => json[sensor_id]['property_name'],
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
