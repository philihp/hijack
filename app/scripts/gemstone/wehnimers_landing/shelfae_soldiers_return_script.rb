load "#{SCRIPTS_DIR}/gemstone/wehnimers_landing/shelfae_soldiers_script.rb", true

class ShelfaeSoldiersReturnScript < ShelfaeSoldiersScript
  protected

  def directions
    reverse_directions(super)
  end
end
