load "#{APP_DIR}/scripts/base/base_script.rb", true

class RestScript < BaseScript
  def run
    loop do
      sleep 60.0
      puts 'experience'
    end
  end
end
