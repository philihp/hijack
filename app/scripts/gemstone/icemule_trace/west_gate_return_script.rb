load "#{APP_DIR}/scripts/gemstone/icemule_trace/west_gate_script.rb", true

class WestGateReturnScript < WestGateScript
  protected

  def directions
    reverse_directions(super)
  end
end
