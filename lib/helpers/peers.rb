module Helpers
  class Peers
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def bgp_sessions
      config.bgp.map(&:sessions).flatten
    end

    def session_name(session)
      if session.alias
        "#{session.alias}_v#{session.protocol_number}"
      else
        if session.index
          index_suffix = "_#{session.index}"
        else
          index_suffix = nil
        end

        "#{session_type(session).upcase}_AS#{session.asn}_v#{session.protocol_number}#{index_suffix}"
      end
    end

    def local_address(session)
      session_local_address = session.local
      type_local_address = session&.defaults&.local&.for(session.protocol_number)
      global_local_address = config.defaults&.local&.for(session.protocol_number)

      session_local_address || type_local_address || global_local_address
    end

    def remote_address(session)
      if session.remote_port
        "#{session.remote} port #{session.remote_port}"
      else
        session.remote
      end
    end

    def session_template_name(session)
      "#{session_type(session)}#{session.protocol_number}"
    end

    def session_type(session)
      session.session_type
    end

    def irr_bgpq3_output(session)
      case session.protocol_number
      when 4
        `bgpq3 -b -A -m 24 -4 -l AS_SET_FOR_#{session.asn}_4 #{session.irr}`
      when 6
        `bgpq3 -b -A -m 48 -6 -l AS_SET_FOR_#{session.asn}_6 #{session.irr}`
      end
    end
  end
end
