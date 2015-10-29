class ServerLogin
  HTTP = 'http://'
  LOGIN_URL = '/api/login'

  def self.login(nextproc)
    if $loginSession == nil
      loginSession(nextproc)
    else
      nextproc.call(true)
    end
  end
  
  def self.loginSession(nextproc)
    if $loginSession != nil
      nextproc.call(true)
    end
    if $settings.server_address == nil || $settings.username == nil || $settings.password == nil
      puts "login information not configured"
      nextproc.call(false)
    end

    url = HTTP + $settings.server_address + LOGIN_URL
    payload = {"username" => $settings.username,
               "password_hash" => RmDigest::SHA256.hexdigest($settings.password)}
    BW::HTTP.post(url, payload: BW::JSON.generate(payload)) do |response|
      if response.ok?
        $loginSession = response.headers['Set-Cookie']
        nextproc.call(true)
      else
        nextproc.call(false)
      end
    end
  end
end
