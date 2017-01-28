load "#{APP_DIR}/scripts/gemstone/icemule_trace/town_center_script.rb", true

class EastGateScript < TownCenterScript
  protected

  def directions
    [
      EAST,
      EAST,
      EAST,
      EAST,
      EAST,
      "go gate|#{EAST}",
      "#{EAST}|go gate",
    ]
  end

  def location
    "east_gate|#{ICEMULE_TRACE}"
  end
end
