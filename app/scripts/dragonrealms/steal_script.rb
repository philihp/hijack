load "#{SCRIPTS_DIR}/base/base_dragonrealms_script.rb", true

class StealScript < BaseDragonrealmsScript
  def run
    shop_entrance = @args[0] || config_shop_entrance
    shop_exit = @args[1] || config_shop_exit
    item = @args[2] || config_item
    item_location = @args[3] || config_item_location
    interloop_sleep_time = (config_interloop_sleep_time || 90.0).to_f
    loop do
      sleep 0.1 until hide
      sneak(shop_entrance)
      first_attempt_succeeded = steal(item, item_location)
      second_attempt_succeeded = first_attempt_succeeded && \
        steal(item, item_location)
      sneak(shop_exit) || move(shop_exit)
      sleep 0.1 until unhide
      drop_my(item) if first_attempt_succeeded
      drop_my(item) if second_attempt_succeeded
      break unless first_attempt_succeeded && second_attempt_succeeded
      sleep interloop_sleep_time
    end
  end

  def validate_args
    @args.length >= 3 || (
      config_shop_entrance.present? &&
      config_shop_exit.present? &&
      config_item.present?
    )
  end

  private

  def config_interloop_sleep_time
    @config[:steal_interloop_sleep_time]
  end

  def config_item
    @config[:steal_item]
  end

  def config_item_location
    @config[:steal_item_location]
  end

  def config_shop_entrance
    @config[:steal_shop_entrance]
  end

  def config_shop_exit
    @config[:steal_shop_exit]
  end
end
