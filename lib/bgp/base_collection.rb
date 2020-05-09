module BGP
  class BaseCollection
    def initialize(attrs, session_class:)
      @attrs = attrs
      @session_class = session_class
    end

    def sessions
      attrs['sessions'].map do |session|
        session['remote'].map do |protocol, remote|
          next if protocol == 'port'

          if remote.respond_to?(:each)
            remote.each_with_index.map do |remote, index|
              build_session(
                attrs: session,
                protocol: protocol,
                defaults: attrs['defaults'],
                remote: remote,
                index: index += 1
              )
            end
          else
            build_session(
              attrs: session,
              protocol: protocol,
              defaults: attrs['defaults'],
            )
          end
        end
      end.flatten.compact
    end

    private

    attr_reader :attrs, :session_class

    def build_session(attrs:, protocol:, remote: nil, defaults: nil, index: nil)
      number = protocol_number_from_config(protocol)

      @session_class.new(
        protocol_number: number,
        description: attrs.dig('description'),
        asn: attrs.dig('asn'),
        local: attrs.dig('local', protocol),
        remote: remote || attrs.dig('remote', protocol),
        remote_port: attrs.dig('remote', 'port'),
        md5: attrs.dig('md5'),
        irr: attrs.dig('irr'),
        session_alias: attrs.dig('alias'),
        disabled: attrs.dig('disabled'),
        allowed_prefixes: attrs.dig('allowed_prefixes'),
        defaults: defaults,
        route_reflector: attrs.dig('route_reflector'),
        multihop: attrs.dig('multihop'),
        communities: attrs.dig('communities'),
        index: index
      )
    end

    def protocol_number_from_config(entry)
      case entry
      when 'v4' then 4
      when 'v6' then 6
      end
    end

    def session_class
      raise NotImplementedError
    end
  end
end
