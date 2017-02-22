module Flumtter
  module Command::DM
    def add_command(twitter)
      command("r", "Reply") do |m|
        error_handler do
          obj, m2 = parse_index(m[1])
          twitter.rest.create_direct_message(obj.sender.id, m2)
        end
      end
    end
  end
end
