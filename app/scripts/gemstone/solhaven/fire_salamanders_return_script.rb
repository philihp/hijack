load "#{APP_DIR}/scripts/gemstone/solhaven/fire_salamanders_script.rb", true

class FireSalamandersReturnScript < FireSalamandersScript
  protected

  def directions
    reverse_directions(super)
  end
end
