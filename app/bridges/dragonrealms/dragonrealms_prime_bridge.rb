require 'bridges/base/base_dragonrealms_bridge'

class DragonrealmsPrimeBridge < BaseDragonrealmsBridge
  def initialize(config)
    super
    @config.merge!({
      :game_host => 'dr.simutronics.net',
      :game_port => 4901,
      :game_code => 'DR',
      :lich_net_channel => 'DRPrime',
    })
  end
end
