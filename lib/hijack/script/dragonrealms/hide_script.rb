require 'hijack/script/base_script'

class HideScript < BaseScript

  def run(args)
    num_iterations = (args[0] || 1).to_i
    num_iterations.times do |i|
      puts 'hide'
      sleep 6.5
      puts 'unhide'
      sleep 1.5
    end
    num_reinvocations = args[1].to_i
    if num_reinvocations > 0
      puts ";wait 15 ;hide #{num_iterations} #{num_reinvocations - 1}"
    end
  end

end
