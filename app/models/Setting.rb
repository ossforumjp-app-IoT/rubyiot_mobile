class Settings

  class << self
    def instance
      Dispatch.once { @instance ||= Settings.new }
      @instance
    end
  end

  # 各種設定の名前
#  Properties = %w(server_address server_port)
  Properties = %w(server_address)
  
  # getter、setterを動的に生成
  Properties.each do |name|
    define_method("#{name}=") do |v|
      App::Persistence[name] = v
    end
    define_method("#{name}") do
      App::Persistence[name]
    end
  end
end
