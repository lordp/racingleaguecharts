# This file is used by Rack-based servers to start the application.

require 'faye'
bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)

bayeux.on(:subscribe) do |client_id, channel|
  puts "[  SUBSCRIBE] #{client_id} -> #{channel}"
end

bayeux.on(:unsubscribe) do |client_id, channel|
  puts "[UNSUBSCRIBE] #{client_id} -> #{channel}"
end

run bayeux
