load "#{MIXINS_DIR}/base/return_movement_script_mixin.rb", true
load "#{SCRIPTS_DIR}/dragonrealms/crossing/outside_alchemist_script.rb", true

class OutsideAlchemistReturnScript < OutsideAlchemistScript
  include ReturnMovementScriptMixin
end
