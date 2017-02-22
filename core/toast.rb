require 'terminal-notifier'

module Flumtter
  class Toast
    Options = {
      title: TITLE,
    }

    class << self
      def show(msg, options={})
        TerminalNotifier.notify(msg, Options.merge(options)) if Setting[:toast?]
      end
    end
  end
end
