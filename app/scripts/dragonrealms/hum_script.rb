load "#{SCRIPTS_DIR}/base/base_dragonrealms_script.rb", true

class HumScript < BaseDragonrealmsScript
  YOU_FINISH_HUMMING = 'You finish humming'

  def run
    song = @args[0] || config_hum_song
    loop do
      # regardless of the output from this command we will be in the expected
      # state for the match below
      puts "hum #{song}"
      # eventually the song will conclude, this is our cue to restart
      wait_for_match(YOU_FINISH_HUMMING)
    end
  end

  def validate_args
    @args.length == 1 ||
      config_hum_song.present?
  end

  private

  def config_hum_song
    @config[:hum_song]
  end
end
