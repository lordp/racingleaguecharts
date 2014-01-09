require 'socket'
require 'json'
require 'csv'
require_relative 'telemetry'

class UDPServer
  def initialize(port)
    @port = port
    @clients = {}
  end

  def start
    @socket = UDPSocket.new
    @socket.bind('0.0.0.0', @port)
    @token = Session::generate_token
    while true
      data, client = @socket.recvfrom(1024)
      ip = client[2]

      t = Telemetry.new(ip, data.unpack('f*')).save
      unless @clients.include?(ip)
        @clients[ip] = Session.find_or_create_by_token_and_session_type(@token, t.session_type)
        @clients[ip].set_info(ip, t.track_length)
      end

      # If the track or session type changes, start a new session
      if t.track_length != @clients[ip].track_length || t.session_type != @clients[ip].session_type
        @token = Session::generate_token
        @clients[ip] = Session.find_or_create_by_token_and_session_type(@token, t.session_type)
        @clients[ip].set_info(ip, t.track_length)
      end

      if t.sector == 1 && t.time_sector1 > 0
        @clients[ip].set_sector_time(1, t.time_sector1, t.lap)
      end

      if t.sector == 2 && t.time_sector2 > 0
        @clients[ip].set_sector_time(2, t.time_sector2, t.lap)
      end

      if t.sector == 0 && @clients[ip].lap && @clients[ip].lap.lap_number != t.lap && t.previous_lap_time > 0
        @clients[ip].set_lap_time(t.previous_lap_time)
      end
    end
  end
end

server = UDPServer.new(20777)
server.start
