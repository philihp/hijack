load "#{SCRIPTS_DIR}/gemstone/wehnimers_landing/town_square_central_script.rb", true

class GemshopScript < TownSquareCentralScript
  protected

  def directions
    super + [
      SOUTHWEST,
      SOUTH,
      SOUTH,
      SOUTH,
      EAST,
      "go shop|#{OUT}",
    ]
  end

  def location
    "gemshop|#{WEHNIMERS_LANDING}"
  end
end
