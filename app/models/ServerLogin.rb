class ServerLogin
  HTTP = 'http://'
  LOGIN_URL = '/api/login'

  def self.login(nextproc, block)
    if $loginSession == nil
      loginSession(nextproc, block)
    else
      nextproc.call(true, block)
    end
  end
  
  def self.loginSession(nextproc, block)
    if $loginSession != nil
      nextproc.call(true, block)
    end
    if $settings.server_address == nil || $settings.username == nil || $settings.password == nil
      puts "login information not configured"
      nextproc.call(false, block)
    end

    url = HTTP + $settings.server_address + LOGIN_URL
    payload = {"username" => $settings.username,
               "password_hash" => RmDigest::SHA256.hexdigest($settings.password)}
    BW::HTTP.post(url, payload: BW::JSON.generate(payload)) do |response|
      if response.ok?
        $loginSession = response.headers['Set-Cookie']
        nextproc.call(true, block)
      else
        nextproc.call(false, block)
      end
    end
  end
end
