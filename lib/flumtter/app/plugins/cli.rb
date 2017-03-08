module Flumtter
  plugin do
    Cli.add("--tweet VALUES", "new tweet") do |twitter, args|
      twitter.rest.update(args)
    end
    Cli.add("--tweet_with_image=V,V", Array, "new tweet with image") do |twitter, (tweet, file)|
      begin
        twitter.rest.update_with_media(tweet, open(file))
      rescue Twitter::Error::Forbidden => e
        if e.message == "Error creating status."
          STDERR.puts "This file is not supported."
        else
          raise e
        end
      end
    end
    add_opt do |opt, options|
      opt.on('-l', '--list', 'user list') do
        puts AccountSelector.list_to_s
        exit
      end
    end
  end
end
