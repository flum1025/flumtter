# Coding: UTF-8
require 'oauth'
require 'oauth/consumer'

@userConfig[:db_init] ||= []
@userConfig[:db_init] << "CREATE TABLE IF NOT EXISTS token(user_id TEXT UNIQUE, screen_name TEXT, consumer_key TEXT, consumer_secret TEXT, access_token TEXT, access_secret TEXT)"

def oauth_first
  print "Enter your consumer_key:"
  consumer_key = STDIN.gets.chomp
  print "Enter your consumer_secret:"
  consumer_secret = STDIN.gets.chomp
  consumer = OAuth::Consumer.new(consumer_key ,consumer_secret,{
    :site=>"https://api.twitter.com"
  })
  request_token = consumer.get_request_token
  puts "Please access this URL"
  puts ":#{request_token.authorize_url}"
  puts "and get the Pin code."
  print "Enter your Pin code:"
  pin  = STDIN.gets.chomp
  access_token = request_token.get_access_token(:oauth_verifier => pin)
  config [0, 0, consumer_key, consumer_secret, access_token.token, access_token.secret]
  user_id, screen_name = [:id, :screen_name].map{|x| @rest_client.user.send(x) }
  @sqlite.execute"INSERT INTO token VALUES (?,?,?,?,?,?)", [user_id, screen_name, consumer_key, consumer_secret, access_token.token, access_token.secret]
rescue OAuth::Unauthorized
  puts text_color("Unauthorized", color=:red)
  exit
end

def oauth_load
  return @sqlite.execute("SELECT * FROM token;")
end

def oauth_check
  rows = @sqlite.execute("SELECT user_id FROM token;")
  if rows[0].nil?
    oauth_first
  end
end