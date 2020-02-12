class Rack::Attack
  throttle('req/ip', :limit => 300, :period => 5.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end
  throttle('logins/ip', :limit => 5, :period => 10.seconds) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end
end
