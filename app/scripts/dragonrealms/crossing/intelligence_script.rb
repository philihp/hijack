load "#{SCRIPTS_DIR}/dragonrealms/crossing/outside_asemath_academy_script.rb", true

class IntelligenceScript < OutsideAsemathAcademyScript
  protected

  def directions
    super + [
      "go academy|#{OUT}",
      'go memorial arch',
      WEST,
      WEST,
      NORTH,
      "#{NORTHEAST}|#{OUT}",
    ]
  end

  def location
    "intelligence|#{CROSSING}"
  end
end
