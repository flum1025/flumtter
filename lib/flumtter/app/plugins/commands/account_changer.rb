module Flumtter
  plugin do
    Keyboard.add("a", "Account Selector") do |m, twitter|
      if account = AccountSelector.select
        twitter.kill
        twitter.set account
        twitter.start
      else
        puts 'not change'
      end
    end
  end
end
