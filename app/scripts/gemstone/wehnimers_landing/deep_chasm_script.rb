load "#{SCRIPTS_DIR}/gemstone/wehnimers_landing/glacier_script.rb", true

class DeepChasmScript < GlacierScript
  protected

  def directions
    super + [
      NORTHEAST,
      NORTH,
      EAST,
      NORTHEAST,
      NORTHEAST,
      EAST,
      NORTHEAST,
      SOUTHEAST,
      EAST,
      SOUTHEAST,
      EAST,
      SOUTHEAST,
    ]
  end

  def location
    "deep_chasm|#{WEHNIMERS_LANDING}"
  end
end
