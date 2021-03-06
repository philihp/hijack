load "#{SCRIPTS_DIR}/base/base_dragonrealms_combat_script.rb", true

class SliceScript < BaseDragonrealmsCombatScript
  protected

  def combat_sequence
    [
      ['feint', 2.5],
      ['slice', 3.5],
      ['draw', 3.5],
      ['chop', 4.5],
    ]
  end
end
