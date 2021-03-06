load "#{SCRIPTS_DIR}/gemstone/icemule_trace/west_gate_script.rb", true

class IcyTrenchScript < WestGateScript
  protected

  def directions
    super + [
      WEST,
      WEST,
      SOUTHWEST,
      SOUTHWEST,
      'go trail',
      NORTH,
      NORTHWEST,
      WEST,
      'go path',
      NORTH,
    ]
  end

  def location
    "icy_trench|#{ICEMULE_TRACE}"
  end
end
