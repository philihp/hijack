class LichNetHelper
  # general
  CHANNEL = 'channel'
  CHAT = 'chat'
  CHAT_TO = 'chat_to'
  FROM = 'from'
  LNET = 'LNet'
  LOGIN = 'login'
  MESSAGE = 'message'
  PING = 'ping'
  PRIVATE = 'private'
  PRIVATETO = 'privateto'
  EXIT_QUIT = /exit|quit/
  SERVER = 'server'
  TO = 'to'
  TUNE = 'tune'
  TYPE = 'type'
  UNTUNE = 'untune'

  # formatting
  CHANNEL_MESSAGE_FORMAT = '[%s] %s: "%s"'
  CHANNEL_WITHOUT_PREFIX_FORMAT = %{#{LNET}:%s}
  PRIVATETO_MESSAGE_FORMAT = %{[#{LNET}:PrivateTo] %s: "%s"}
  PRIVATE_MESSAGE_FORMAT = %{[#{LNET}:Private] %s: "%s"}
  SERVER_MESSAGE_FORMAT = %{[#{LNET}:Server] %s}

  # defaults
  DEFAULT_CHANNEL = LNET
  DEFAULT_HOST = 'lnet.lichproject.org'
  DEFAULT_PORT = 7155
  DEFAULT_SSL_VERSION = :TLSv1
  DEFAULT_OUTPUT_FORMAT = '%s'

  def initialize(opts={})
    @game = opts[:game]
    @name = opts[:name]
    @channel = opts[:channel] || DEFAULT_CHANNEL
    @host = opts[:host] || DEFAULT_HOST
    @port = opts[:port].to_s =~ /\A(\d+)\Z/ ? $1.to_i : DEFAULT_PORT
    @ssl_version = (opts[:ssl_version] || DEFAULT_SSL_VERSION).to_sym
    @stdin = opts[:stdin] || STDIN
    @stdout = opts[:stdout] || STDOUT
    @stderr = opts[:stderr] || STDERR
    @output_format = opts[:output_format] || DEFAULT_OUTPUT_FORMAT
    @debug = opts[:debug].to_s == 'true'
    @logging_helper = opts[:logging_helper] || \
      LoggingHelper.new(:exception_log => @stderr)
  end

  def connect
    validate_args
    initialize_network
    login
    initialize_threads
  end

  def connected?
    @ssl_socket.present? &&
      !@ssl_socket.closed?
  end

  def disconnect
    @ssl_socket.close rescue nil
    @ssl_socket = nil
  end

  private

  def chat(message)
    if message.present?
      write(MESSAGE, {
        :type => CHANNEL,
        :channel => @channel,
        :message => message,
      })
    end
  end

  def chat_to(to, message)
    if [to, message].all?(&:present?)
      write(MESSAGE, {
        :type => PRIVATE,
        :to => to,
        :message => message,
      })
    end
  end

  def debug?
    !!@debug
  end

  def initialize_certificate
    @certificate ||= begin
      certificate = OpenSSL::X509::Certificate.new
      certificate.not_before = Time.now
      certificate.not_after = Time.now + 3600
      certificate.public_key = @private_key.public_key
      certificate.sign(@private_key, OpenSSL::Digest::SHA1.new)
      certificate
    end
  end

  def initialize_network
    initialize_private_key
    initialize_certificate
    initialize_tcp_socket
    initialize_ssl_context
    initialize_ssl_socket
  end

  def initialize_ping_thread
    @ping_thread ||= Thread.new do
      while connected?
        write(PING) if (Time.now - @last_write) >= 60
        sleep 1.0
      end
    end
  end

  def initialize_private_key
    @private_key ||= OpenSSL::PKey::RSA.new(512)
  end

  def initialize_read_thread
    @read_thread ||= Thread.new do
      while connected?
        (read || []).each do |value|
          @stdout.puts(@output_format % value)
        end
      end
    end
  end

  def initialize_ssl_context
    @ssl_context ||= begin
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_context.key = @private_key
      ssl_context.cert = @certificate
      ssl_context.ssl_version = @ssl_version
      ssl_context
    end
  end

  def initialize_ssl_socket
    @ssl_socket ||= begin
      ssl_socket = OpenSSL::SSL::SSLSocket.new(@tcp_socket, @ssl_context)
      ssl_socket.sync_close = true
      ssl_socket.connect
      ssl_socket
    end
  end

  def initialize_tcp_socket
    @tcp_socket ||= begin
      tcp_socket = TCPSocket.open(@host, @port)
      tcp_socket.sync = true
      tcp_socket
    end
  end

  def initialize_threads
    initialize_read_thread
    initialize_write_thread
    initialize_ping_thread
  end

  def initialize_write_thread
    @write_thread ||= Thread.new do
      while connected?
        value = @stdin.gets.rstrip
        value_parts = value.split(' ')
        command = value_parts[0]
        case command
        when CHAT
          # format: chat <message>
          chat(value_parts[1..-1].join(' '))
        when CHAT_TO
          # format: chat_to <to> <message>
          chat_to(value_parts[1], value_parts[2..-1].join(' '))
        when EXIT_QUIT
          # format: exit|quit
          disconnect
        when TUNE
          # format: tune <channel>
          tune(value_parts[1])
        when UNTUNE
          # format: untune <channel>
          untune(value_parts[1])
        else
          @stderr.puts(@output_format % \
            %{#{LichNetHelper}: unexpected command: "#{command}"})
        end
      end
    end
  end

  def login
    write(LOGIN, {
      :game => @game,
      :name => @name,
    })
  end

  def map_and_filter_messages(document)
    (document.elements || []).map do |element|
      if element.name == MESSAGE
        channel = element.attributes[CHANNEL]
        if channel.present? && !channel.include?(LNET)
          channel = CHANNEL_WITHOUT_PREFIX_FORMAT % channel
        end
        from = element.attributes[FROM]
        text = element.text
        to = element.attributes[TO]
        type = element.attributes[TYPE]
        case type
        when CHANNEL
          CHANNEL_MESSAGE_FORMAT % [
            channel,
            from,
            text,
          ]
        when PRIVATETO
          PRIVATETO_MESSAGE_FORMAT % [
            to,
            text,
          ]
        when PRIVATE
          PRIVATE_MESSAGE_FORMAT % [
            from,
            text,
          ]
        when SERVER
          SERVER_MESSAGE_FORMAT % text
        else
          @stderr.puts(@output_format % \
            %{#{LichNetHelper}: unexpected message-type: "#{type}"})
          nil
        end
      end
    end.compact
  end

  def read
    begin
      value = @ssl_socket.gets
      document = REXML::Document.new(value)
      map_and_filter_messages(document)
    rescue REXML::ParseException => e
      @logging_helper.log_exception_with_backtrace(e) if debug?
    end
  end

  def tune(channel)
    if channel.present?
      write(TUNE, {
        :channel => @channel = channel,
      })
    end
  end

  def untune(channel)
    if channel.present?
      write(UNTUNE, {
        :channel => @channel = channel,
      })
    end
  end

  def validate_args
    if [@game, @name].any?(&:blank?)
      raise \
        %{"#{LichNetHelper}" is missing one or more required configuration values}
    end
  end

  def write(tag, attributes={})
    document = REXML::Document.new
    element = document.add_element(tag)
    element.text = attributes.delete(:message)
    attributes.each { |key, value| element.add_attribute(key.to_s, value) }
    @ssl_socket.puts(document)
    @last_write = Time.now
    nil
  end
end

if $0 == __FILE__
  lichnet_helper = LichNetHelper.new(
    :game => ENV['GAME'],
    :name => ENV['NAME'],
    :channel => ENV['CHANNEL'],
    :host => ENV['HOST'],
    :port => ENV['PORT'],
    :ssl_version => ENV['SSL_VERSION'],
    :output_format => ENV['OUTPUT_FORMAT'],
    :debug => ENV['DEBUG']
  )
  lichnet_helper.connect.join
end
