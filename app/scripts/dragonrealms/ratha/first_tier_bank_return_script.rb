load "#{APP_DIR}/scripts/dragonrealms/ratha/first_tier_bank_script.rb", true

class FirstTierBankReturnScript < FirstTierBankScript
  protected

  def directions
    reverse_directions(super)
  end
end
