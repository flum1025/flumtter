require 'twitter'

module Flumtter
  class Twitter
    @@events = {}

    def self.on_event(event,&blk)
      @@events[event] ||= []
      @@events[event] << blk
    end

    def callback(event, object)
      return if !@@events[event]
      @@events[event].each do |c|
        c.call(object)
      end
    end

    attr_reader :rest, :stream, :thread, :name, :id

    def initialize(keys)
      @name = keys[:screen_name]
      @id = keys[:id]
      @keys = keys
      @rest = ::Twitter::REST::Client.new keys
      @stream = ::Twitter::Streaming::Client.new keys
      @queue = Queue.new
      @pause = false
      @mutex = Mutex.new
    end
    
    def read_buf(count=50)
      Window.update
      @rest.home_timeline(count: count).reverse_each do |object|
        TimeLineElement::Tweet.new(object)
      end
    end

    def change(keys=@keys)
      kill
      @name = keys[:screen_name]
      @id = keys[:id]
      @rest = ::Twitter::REST::Client.new keys
      @stream = ::Twitter::Streaming::Client.new keys
    end

    def kill
      @thread.kill if !@thread.nil?
      @ethread.kill if !@ethread.nil?
      @queue.clear
    end

    def stream(options={})
      puts "@#{@name}'s stream_start!"
      print "@#{@name} #{TITLE}".title
      execute
      @thread = Thread.new do
        begin
          @stream.user(options) do |object|
            Window.update
            kind = case object
            when ::Twitter::Tweet
              :tweet
            when ::Twitter::Streaming::Event
              case object.name.to_s
              when "favorite"
                :favorite
              when "unfavorite"
                :unfavorite
              when "follow"
                :follow
              when "unfollow"
                :unfollow
              else
                :event
              end
            when ::Twitter::Streaming::FriendList
              :friendlist
            when ::Twitter::Streaming::DeletedTweet
              :deletedtweet
            when ::Twitter::DirectMessage
              :directmessage
            end
            @queue.push [kind, object]
          end
        rescue EOFError
          p :EOFError
          retry
        end
      end
    end

    def execute
      @ethread = Thread.new do
        loop do
          kind, object = @queue.pop
          begin
            @mutex.lock
            callback(kind, [object,self])
          ensure
            begin
              @mutex.unlock
            rescue ThreadError
            end
          end
        end
      end
    end

    def pause
      @mutex.lock
    end

    def resume
      @mutex.unlock
    end
  end
end