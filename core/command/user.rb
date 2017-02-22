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
        error_handler do
          twitter.rest.follow(user.screen_name)
          Window::Popup::Success.new("follow success").show
        end
      end
      command("unfollow", "Unfollow") do
        error_handler do
          twitter.rest.unfollow(user.screen_name)
          Window::Popup::Success.new("unfollow success").show
        end
      end
      command("block", "Block") do
        error_handler do
          twitter.rest.block(user.screen_name)
          Window::Popup::Success.new("block success").show
        end
      end
      command("unblock", "UnBlock") do
        error_handler do
          twitter.rest.unblock(user.screen_name)
          Window::Popup::Success.new("unblock success").show
        end
      end
    end
  end
end
