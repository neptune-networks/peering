require_relative 'bgp/base_collection'
require_relative 'bgp/base_session'

module BGP
  class CoreSession < BaseSession; end
  class UpstreamSession < BaseSession; end
  class CustomerSession < BaseSession; end
  class PeerSession < BaseSession; end
  class TelemetrySession < BaseSession; end
  class LookingGlassSession < BaseSession; end

  class CoreSessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: CoreSession)
    end
  end

  class UpstreamSessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: UpstreamSession)
    end
  end

  class CustomerSessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: CustomerSession)
    end
  end

  class PeerSessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: PeerSession)
    end
  end

  class TelemetrySessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: TelemetrySession)
    end
  end

  class LookingGlassSessionCollection < BaseCollection
    def initialize(attrs)
      super(attrs, session_class: LookingGlassSession)
    end
  end
end
