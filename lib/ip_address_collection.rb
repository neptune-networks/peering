class IPAddressCollection
  attr_reader :v4, :v6

  def initialize(attrs)
    return unless attrs

    @v4 = attrs['v4']
    @v6 = attrs['v6']
  end

  def for(protocol_number)
    case protocol_number
    when 4 then v4
    when 6 then v6
    end
  end
end

class Local < IPAddressCollection; end
class Remote < IPAddressCollection; end
class PreferredSource < IPAddressCollection; end
class Originations < IPAddressCollection; end
class Whitelist < IPAddressCollection; end
class Blacklist < IPAddressCollection; end
class StaticRoutes < IPAddressCollection; end
class AllowedPrefixes < IPAddressCollection; end
