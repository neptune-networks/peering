require_relative 'ip_address_collection'
require_relative 'defaults_collection'
require_relative 'rpki'
require_relative 'bgp'

class Configuration
  def self.from_yaml(file)
    attrs = YAML.load_file(file)
    new(attrs)
  end

  def initialize(attrs)
    @attrs = attrs
  end

  def originations
    @originations ||= Originations.new(attrs['originations'])
  end

  def preferred_source
    @preferred_source ||= PreferredSource.new(attrs['preferred_source'])
  end

  def whitelist
    @whitelist ||= Whitelist.new(attrs['whitelist'])
  end

  def blacklist
    @blacklist ||= Blacklist.new(attrs['blacklist'])
  end

  def rpki
    @rpki ||= RPKI.new(host: attrs.dig('rpki', 'host'), port: attrs.dig('rpki', 'port'))
  end

  def static_routes
    @static_routes ||= StaticRoutes.new(attrs['static_routes'])
  end

  def defaults
    return unless default_attrs = attrs['defaults']
    @defaults ||= DefaultsCollection.new(default_attrs)
  end

  def bgp
    attrs['bgp'].map do |type, config|
      case type
      when 'cores'
        BGP::CoreSessionCollection.new(config)
      when 'upstreams'
        BGP::UpstreamSessionCollection.new(config)
      when 'customers'
        BGP::CustomerSessionCollection.new(config)
      when 'peers'
        BGP::PeerSessionCollection.new(config)
      when 'telemetries'
        BGP::TelemetrySessionCollection.new(config)
      when 'looking_glasses'
        BGP::LookingGlassSessionCollection.new(config)
      else
        raise NotImplementedError
      end
    end.flatten
  end

  def method_missing(method_name, *args, &block)
    if attrs.keys.include?(method_name.to_s)
      attrs[method_name.to_s]
    else
      super
    end
  end

  private

  attr_reader :attrs
end
