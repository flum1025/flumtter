module Flumtter
  class Cli
    class Command
      def initialize(blk, args)
        @blk = blk
        @args = args
      end

      def run(twitter)
        @blk.call(twitter, @args)
      end
    end

    @@events = []
    class << self
      def add(*args, &blk)
        Initializer.add_opt do |opt, options|
          opt.on(*args){|v|options[args.first] = v}
        end
        Initializer.run(args.first) do |v, options|
          @@events << Command.new(blk, v)
        end
      end

      def run(client)
        unless @@events.empty?
          @@events.map{|event|event.run(client)}
          exit
        end
      end

      def multiuser(twitter)
        if Setting[:names]
          Setting[:names].each do |name|
            twitter.set AccountSelector.select(name: name)
            yield
          end
        else
          yield
        end
      end
    end
  end
end
