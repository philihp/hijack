class BaseScript

  def initialize(config, stdin, stdout, on_exec=nil, on_exit=nil, on_kill=nil)
    @config, @stdin, @stdout, @on_exec, @on_exit, @on_kill = config, stdin, stdout, on_exec, on_exit, on_kill
  end

  def start_run(args)
    @thread ||= Thread.new {
      @on_exec.call rescue nil
      run(args)
      @on_exit.call rescue nil
    }
  end

  def kill!
    if running?
      @thread.kill
      @on_kill.call rescue nil
    end
  end

  def run(args)
    raise 'All Scripts(s) must override the "run" method'
  end

  def validate_args(args)
    true
  end

  def running?
    !@thread.nil? && @thread.alive?
  end

  protected

  def gets
    @stdout.gets
  end

  def puts(command)
    @stdin.puts(command)
  end

end
