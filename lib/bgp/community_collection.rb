module BGP
  class CommunityCollection
    attr_reader :import, :export

    def initialize(attrs)
      @import = attrs['import']
      @export = attrs['export']
    end
  end
end
