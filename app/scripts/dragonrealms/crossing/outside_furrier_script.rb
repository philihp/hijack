load "#{SCRIPTS_DIR}/dragonrealms/crossing/outside_apostle_headquarters_script.rb", true

class OutsideFurrierScript < OutsideApostleHeadquartersScript
  protected

  def directions
    super + [
      WEST,
      WEST,
      NORTH,
      NORTH,
      WEST,
    ]
  end

  def location
    "outside_furrier|#{CROSSING}"
  end
end
