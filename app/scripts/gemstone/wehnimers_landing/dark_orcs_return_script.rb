load "#{MIXINS_DIR}/base/return_movement_script_mixin.rb", true
load "#{SCRIPTS_DIR}/gemstone/wehnimers_landing/dark_orcs_script.rb", true

class DarkOrcsReturnScript < DarkOrcsScript
  include ReturnMovementScriptMixin
end
