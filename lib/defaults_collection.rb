class DefaultsCollection
  def initialize(attrs)
    return unless attrs
    @attrs = attrs
  end

  def local
    return unless attrs&.dig('local')
    ::Local.new(attrs['local'])
  end

  def remote
    return unless attrs&.dig('remote')
    ::Remote.new(attrs['remote'])
  end

  private

  attr_reader :attrs
end
