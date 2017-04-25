module Flumtter
  plugin do
    self::PluginDir = UserPath.join("plugins", "repo")
    FileUtils.mkdir_p(self::PluginDir) unless FileTest.exist?(self::PluginDir)
    self::Plugins = Dir.glob(File.join(self::PluginDir, "*/*/"))
    File.join(self::PluginDir, "*/*/")
    sarastire_user 'plugins/repo', '**/*.rb'

    class self::Base < Window::Buf::Element
      def self.parse_name(filename)
        pname = Pathname(Plugins::PluginManager::PluginDir)
        Pathname(filename).relative_path_from(pname).to_s
      end

      def element
        @text ||= <<~EOF
          #{@index}: #{name}
        EOF
      end

      private
      def name
        self.class.parse_name(@object)
      end
    end

    class self::Buf < Window::Buf::Buf
      def initialize
        super(Plugins::PluginManager::Base)
      end

      def prefetch
        if @buf.empty?
          adds(Plugins::PluginManager::Plugins)
        end
      end
    end

    class self::PluginManager < Window::Buf::Screen
      def initialize
        super(Plugins::PluginManager::Buf.new, "PluginManager")
        unless indexes.empty?
          command(/^del\s+[#{indexes}]/, 'delete plugin(index)') do |m|
            FileUtils.rm_r(Plugins::PluginManager::Plugins.delete_at(m[1].to_i))
            Window.close
          end
        end
        command(/^update/, 'update all plugins') do
          Plugins::PluginManager::Plugins.each do |plugin|
            `cd #{plugin}; git pull`; sleep 10
          end
        end
      end

      private
      def indexes
        Plugins::PluginManager::Plugins.size.times.to_a.join(",")
      end
    end

    Keyboard.add(";", "Plugin Manager") do
      self::PluginManager.new.show
    end

    add_opt do |opt, options|
      opt.on('--add_plugin VALUES', "add new plugin") do |v|
        if m = v.match(/[(:\/\/)@].+[:\/](.+)\/(.+?)(\.git)?$/)
          `git clone #{v} #{File.join(self::PluginDir, m[1], m[2])}`
        else
          STDERR.puts "ERROR: invalid path".color
        end
        exit
      end
    end

    add_opt do |opt, options|
      opt.on('--plugins', 'show plugins') do
        self::Plugins.each do |plugin|
          puts self::Base.parse_name(plugin)
        end
        exit
      end
    end
  end
end
