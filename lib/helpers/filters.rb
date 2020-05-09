module Helpers
  class Filters
    attr_reader :session

    def initialize(session)
      @session = session
    end

    def export_communities(session)
      if session.communities&.export
        session.communities.export.map do |community|
          parts = community.split(':')
          case parts.size
          when 2 then "bgp_community.add((#{parts.join(', ')}));"
          when 3 then "bgp_large_community.add((#{parts.join(', ')}));"
          end
        end
      end
    end
  end
end
