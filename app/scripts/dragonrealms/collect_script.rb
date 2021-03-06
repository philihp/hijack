load "#{SCRIPTS_DIR}/base/base_dragonrealms_script.rb", true

class CollectScript < BaseDragonrealmsScript
  THE_ROOM_IS_TOO_CLUTTERED = 'The room is too cluttered'
  YOU_ARE_CERTAIN_YOU_COULD = 'You are certain you could'
  YOU_ARE_SURE_YOU_KNEW = 'You are sure you knew'
  YOU_CANT_DO_THAT_FROM = "You can't do that from"
  YOU_FORAGE_AROUND_BUT = 'You forage around but'
  YOU_MANAGE_TO_COLLECT = 'You manage to collect'
  YOU_REALLY_NEED_TO_HAVE_AT_LEAST = 'You really need to have at least'
  YOU_TAKE_A_STEP_BACK = 'You take a step back'
  YOU_WANDER_AROUND_AND = 'You wander around and'

  COLLECT_FAILURE_PATTERN = [
    YOU_ARE_CERTAIN_YOU_COULD,
    YOU_ARE_SURE_YOU_KNEW,
    YOU_FORAGE_AROUND_BUT,
    YOU_WANDER_AROUND_AND,
  ].join('|')

  COLLECT_FATAL_FAILURE_PATTERN = [
    THE_ROOM_IS_TOO_CLUTTERED,
    YOU_REALLY_NEED_TO_HAVE_AT_LEAST,
  ].join('|')

  COLLECT_PATTERN = [
    THE_ROOM_IS_TOO_CLUTTERED,
    YOU_ARE_CERTAIN_YOU_COULD,
    YOU_ARE_SURE_YOU_KNEW,
    YOU_FORAGE_AROUND_BUT,
    YOU_MANAGE_TO_COLLECT,
    YOU_REALLY_NEED_TO_HAVE_AT_LEAST,
    YOU_WANDER_AROUND_AND,
  ].join('|')

  KICK_PATTERN = [
    I_COULD_NOT_FIND,
    YOU_CANT_DO_THAT_FROM,
    YOU_TAKE_A_STEP_BACK,
  ].join('|')

  def run
    item = @args[0] || config_item
    interloop_sleep_time = (config_interloop_sleep_time || 30.0).to_f
    loop do
      result = wait_for_match(
        COLLECT_PATTERN,
        "collect #{item}"
      )
      case result
        when COLLECT_FATAL_FAILURE_PATTERN
          return
        when COLLECT_FAILURE_PATTERN
          sleep 5.0
          next
      end
      sleep 15.0
      loop do
        result = wait_for_match(
          KICK_PATTERN,
          'kick pile'
        )
        if result == YOU_CANT_DO_THAT_FROM
          sleep 0.1 until stand
        else
          break
        end
      end
      sleep interloop_sleep_time
    end
  end

  def validate_args
    @args.length == 1 ||
      config_item.present?
  end

  private

  def config_interloop_sleep_time
    @config[:collect_interloop_sleep_time]
  end

  def config_item
    @config[:collect_item]
  end
end
