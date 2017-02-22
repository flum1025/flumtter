require_relative 'Initializer'

module Flumtter
  module Plugins
    module Base
      def add_opt(&blk)
        Initializer.add_opt(&blk)
      end

      def run_opt(*args, &blk)
        Initializer.run(*args, &blk)
      end
    end

    module_function
    def plugin(blk)
      m = self.const_set(File.basename(blk.source_location[0], '.rb').to_camel.to_sym, Module.new)
      m.extend(Base)
      m.extend(Util)
      m.instance_eval(&blk)
    end
  end
end

def plugin(&blk)
  Flumtter::Plugins.plugin(blk)
end
