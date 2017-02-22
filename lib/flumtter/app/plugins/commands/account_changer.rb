module Flumtter
  plugin do
    Keyboard.add("a", "Account Selector") do |m, twitter|
      twitter.kill
      twitter.set AccountSelector.select
      twitter.start
    end
  end
end
