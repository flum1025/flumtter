module Flumtter
  plugin do
    Cli.add("--tweet VALUES", "new tweet") do |twitter, args|
      Cli.multiuser(twitter) do
        twitter.rest.update(args)
      end
    end
    Cli.add("--tweet_with_image=V,V", Array, "new tweet with image") do |twitter, (tweet, file)|
      Cli.multiuser(twitter) do
        begin
          twitter.rest.update_with_media(tweet, open(file))
        rescue Twitter::Error::Forbidden => e
          if e.message == "Error creating status."
            STDERR.puts "This file is not supported.".color
          else
            raise e
          end
        end
      end
    end
    Cli.add("--tpry", "pry with twitter instance") do |twitter|
      binding.pry
    end
    add_opt do |opt, options|
      opt.on('-l', '--list', 'user list') do
        puts AccountSelector.list_to_s
        exit
      end
    end
  end
end
