module Flumtter
  module Command::User
    include Util

    def add_command(user, twitter)
      command("tweet", "Tweet List") do
        error_handler do
          Window::Tweet.new(user, twitter).show
        end
      end
      command("follower", "Follower List") do
        error_handler do
          Window::Follower.new(user, twitter).show
        end
      end
      command("following", "Following List") do
        error_handler do
          Window::Following.new(user, twitter).show
        end
      end
      command("favorite", "Favorite List") do
        error_handler do
          Window::Favorite.new(user, twitter).show
        end
      end
      command("follow", "Follow") do
      end
      command("unfollow", "Unfollow") do
      end
      command("block", "Block") do
      end
      command("unblock", "UnBlock") do
      end
    end
  end
end
