require_relative '../defaults_collection'
require_relative 'community_collection'

module BGP
  class BaseSession
    attr_reader :protocol_number, :description, :asn, :local, :remote,
      :remote_port, :md5, :irr, :alias, :disabled, :allowed_prefixes,
      :defaults, :route_reflector, :multihop, :communities, :index

    def initialize(
      protocol_number:,
      description:,
      asn:,
      local: nil,
      remote: nil,
      remote_port: nil,
      md5: nil,
      irr: nil,
      session_alias: nil,
      disabled: nil,
      allowed_prefixes: nil,
      defaults: nil,
      route_reflector: nil,
      multihop: nil,
      communities: nil,
      index: nil
    )
      @protocol_number = protocol_number
      @description = description
      @asn = asn
      @local = local
      @remote = remote
      @remote_port = remote_port
      @md5 = md5
      @irr = irr
      @alias = session_alias
      @disabled = disabled
      @route_reflector = route_reflector
      @multihop = multihop
      @index = index

      if communities
        @communities = CommunityCollection.new(communities)
      end

      if allowed_prefixes
        @allowed_prefixes = AllowedPrefixes.new(allowed_prefixes)
      end

      if defaults
        @defaults = DefaultsCollection.new(defaults)
      end
    end

    def overrides_template?
      !!custom_import_and_export_template
    end

    def custom_import_and_export_template
      @custom_import_export ||= begin
        helper = Helpers::Filters.new(self)
        render "partials/filters/_#{session_type}.conf.erb", helper
      end
    end

    def session_type
      self.class.name.split('::').last.gsub('Session', '').downcase
    end

    def protocol
      "v#{protocol_number}"
    end

    def bgpq3_output
      return @bgpq3_output if defined?(@bgpq3_output)

      case protocol_number
      when 4
        output = `bgpq3 -b -A -m 24 -4 -l AS_SET_FOR_#{asn}_4 #{irr}`
      when 6
        output = `bgpq3 -b -A -m 48 -6 -l AS_SET_FOR_#{asn}_6 #{irr}`
      end

      if output != ''
        @bgpq3_output = output
      else
        @bgpq3_output = nil
      end
    end
  end
end
