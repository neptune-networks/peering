class RPKI
  attr_reader :host, :port

  def initialize(host: nil, port: nil)
    @host = host
    @port = port
  end
end
