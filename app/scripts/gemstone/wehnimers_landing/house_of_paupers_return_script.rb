load "#{MIXINS_DIR}/base/return_movement_script_mixin.rb", true
load "#{SCRIPTS_DIR}/gemstone/wehnimers_landing/house_of_paupers_script.rb", true

class HouseOfPaupersReturnScript < HouseOfPaupersScript
  include ReturnMovementScriptMixin
end
