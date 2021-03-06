require 'uri'
require 'pg'

class SynapseDb

  class Room
    attr_reader :id, :canonical_alias

    def initialize(row)
      @id = row['room_id']
    end

    def to_s
      @id
    end
  end

  def initialize(database_url)
    uri = URI.parse database_url
    @conn = PG.connect(
                       host: uri.host,
                       port: uri.port,
                       user: uri.user,
                       password: uri.password,
                       dbname: uri.path[1..-1]
    )
  end

  def rooms
    # TODO Get canonical_alias as well
    @conn.exec("SELECT room_id FROM rooms") do |result|
      result.map do |row|
        Room.new row
      end
    end
  end
end
