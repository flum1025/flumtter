require 'terminal-notifier'

module Flumtter
  class Toast
    def initialize(msg)
      @msg = msg
      @options = {title: TITLE}
      if block_given?
        yield(self)
        show
      end
    end

    def show
      TerminalNotifier.notify(@msg, @options)
    end

    def method_missing(method, *args)
      if args.size == 1
        @options[method] = args.first
      else
        super
      end
    end
  end
end
