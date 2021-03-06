load "#{SCRIPTS_DIR}/gemstone/solhaven/north_market_script.rb", true

class PawnshopScript < NorthMarketScript
  protected

  def directions
    super + [
      SOUTHWEST,
      SOUTH,
      "go shop|#{OUT}",
    ]
  end

  def location
    "pawnshop|#{SOLHAVEN}"
  end
end
