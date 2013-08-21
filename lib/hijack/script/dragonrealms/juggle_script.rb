require 'hijack/script/base/base_dragonrealms_script'

class JuggleScript < BaseDragonrealmsScript

  ITS_EASIER_TO_JUGGLE = "It's easier to juggle"
  YOU_CANNOT_JUGGLE = 'You cannot juggle'
  YOU_TOSS = 'You toss'

  JUGGLE_FAILURES = [
    ITS_EASIER_TO_JUGGLE,
    YOU_CANNOT_JUGGLE,
  ]

  JUGGLE_PATTERN = [
    ITS_EASIER_TO_JUGGLE,
    YOU_CANNOT_JUGGLE,
    YOU_TOSS,
  ].join('|')

  def validate_args(args)
    args.length == 2 ||
    (config_jugglies && config_jugglies_container)
  end

  def run(args)
    jugglies = args[0] || config_jugglies
    container = args[1] || config_container
    if open_my(container) && get_my(jugglies, container)
      loop do
        match = wait_for_match(
          JUGGLE_PATTERN,
          "juggle my #{jugglies}"
        )
        break if JUGGLE_FAILURES.include?(match)
        sleep 15
      end
    end
    store_my(jugglies, container)
    close_my(container)
  end

  private

  def config_container
    @config[:config_jugglies_container]
  end

  def config_jugglies
    @config[:juggle_jugglies]
  end

end
