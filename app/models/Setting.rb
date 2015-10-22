# http://qiita.com/torshinor/items/2c783d9ae4696e31a98b
class Settings

  class << self
    def instance
      Dispatch.once { @instance ||= Settings.new }
      @instance
    end
  end

  Properties = %w(server_address username password_hash)
  
  Properties.each do |name|
    define_method("#{name}=") do |v|
      App::Persistence[name] = v
    end
    define_method("#{name}") do
      App::Persistence[name]
    end
  end
end
