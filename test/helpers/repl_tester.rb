require 'thread'
require 'delegate'

# This is for super-high-level integration testing.
class ReplTester
  class Input
    def initialize(tester_mailbox)
      @tester_mailbox = tester_mailbox
    end

    def readline(prompt)
      @tester_mailbox.push prompt
      mailbox.pop
    end

    def mailbox
      Thread.current[:mailbox]
    end
  end

  class Output < SimpleDelegator
    def clear
      __setobj__(StringIO.new)
    end
  end

  def self.start(options = {}, &block)
    Thread.current[:mailbox] = Queue.new
    instance = nil
    input    = Input.new(Thread.current[:mailbox])
    output   = Output.new(StringIO.new)

    redirect_pry_io input, output do
      instance = new(options)
      result = instance.instance_eval(&block)
      instance.ensure_exit
      result
    end
  ensure
    if instance && instance.thread && instance.thread.alive?
      instance.thread.kill
    end
  end

  # Set I/O streams. Out defaults to an anonymous StringIO.
  def self.redirect_pry_io(new_in, new_out = StringIO.new)
    old_in, old_out = Pry.config.input, Pry.config.output
    Pry.config.input, Pry.config.output = new_in, new_out

    begin
      yield
    ensure
      Pry.config.input, Pry.config.output = old_in, old_out
    end
  end

  attr_accessor :thread, :mailbox, :last_prompt

  def initialize(options = {})
    @pry     = Pry.new(options)
    @repl    = Pry::REPL.new(@pry)
    @mailbox = Thread.current[:mailbox]

    @thread  = Thread.new do
      begin
        Thread.current[:mailbox] = Queue.new
        @repl.start
      ensure
        Thread.current[:session_ended] = true
        mailbox.push nil
      end
    end

    wait # wait until the instance reaches its first readline
  end

  # Accept a line of input, as if entered by a user.
  def input(input)
    @pry.output.clear
    repl_mailbox.push input
    wait
    @pry.output.string
  end

  # @private
  def ensure_exit
    input "exit-all"
    raise "REPL didn't die" unless @thread[:session_ended]
  end

  private

  def repl_mailbox
    @thread[:mailbox]
  end

  def wait
    @last_prompt = mailbox.pop
  end
end
