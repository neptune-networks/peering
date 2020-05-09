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
  end
end
