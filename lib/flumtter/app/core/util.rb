module Flumtter
  class UnSupportError < ArgumentError; end
  class NoContentError < ArgumentError; end
  class ExecutedError < StandardError; end

  module Util
    def error(e)
      text = <<~EOF
        #{e.backtrace.shift}: #{e.message} (#{e.class})
        #{e.backtrace.join("\n")}
      EOF
      e.class.ancestors.include?(StandardError) ? logger.error(text) : logger.fatal(text)
      print text.color(Setting[:color][:error])

    end

    def parse_time(time)
      time.getlocal.strftime("%Y/%m/%d %H:%M:%S")
    end

    def parse_index(text, with_screen_name=false)
      if m = text.match(index_regexp)
        obj = id2obj(m[1])
        return obj, m[2]
      end
      if with_screen_name && m = text.match(screen_name_regexp)
        return m[1], m[2]
      end
      raise IndexError
    end

    def id2obj(id)
      obj = TimeLine::Base[id.to_i]
      raise IndexError if obj.nil?
      obj
    end

    def dialog_for_index(title, body, with_screen_name=false)
      dialog = Window::Dialog.new(title, body)
      dialog.command(index_regexp) do |m|
        [id2obj(m[1]), m[2]]
      end
      if with_screen_name
        dialog.command(screen_name_regexp) do |m|
          [m[1], m[2]]
        end
      end
      dialog.show(true, false)
    end

    def index_with_dialog(m, title, body, with_screen_name=false)
      if m.empty?
        dialog_for_index(title, body, with_screen_name)
      else
        parse_index(m, with_screen_name)
      end
    end

    def index_regexp
      /^(\d+)[ |　]*(.*)/
    end

    def screen_name_regexp
      /^([@|＠]*[A-Za-z0-9_]{1,15})[ |　]*(.*)/
    end

    def command_value_regexp(command)
      /^#{command}[ |　]*(.*)/
    end

    def error_handler
      begin
        yield
      rescue IndexError
        Window::Popup::Error.new("Please select correct index.").show
      rescue UnSupportError
        puts "This object is unsupported.".color
      rescue ExecutedError => e
        text = e.message.empty? ? "The operation is already executed." : e.message
        print text.dnl.color(:cyan)
      rescue NoContentError
        puts "Please input content.".color
      rescue Twitter::Error::NotFound => e
        puts e.message.color
      rescue Twitter::Error::Unauthorized => e
        puts e.message.color
      rescue Twitter::Error::Forbidden => e
        puts e.message.color
      end
    end

    def if_tweet(obj, twitter)
      case obj
      when Twitter::Tweet
        yield(obj)
      when Twitter::Streaming::Event
        type = obj.type(twitter)
        if type.include?(:favorite) || type.include?(:unfavorite)
          yield(obj.target_object)
        else
          raise UnSupportError
        end
      else
        raise UnSupportError
      end
    end

    def logger
      Flumtter.logger
    end

    def sarastire(*args)
      Flumtter.sarastire(*args)
    end

    def sarastire_user(*args)
      Flumtter.sarastire_user(*args)
    end

    def on_event(*args,&blk)
      Flumtter.on_event(*args,&blk)
    end
  end
end
