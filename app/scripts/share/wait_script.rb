load "#{APP_DIR}/scripts/base/base_script.rb", true

class WaitScript < BaseScript
  def run
    sleep @args[0].to_f
    puts @args[1..-1].join(' ')
  end

  def validate_args
    @args.length >= 2
  end
end
