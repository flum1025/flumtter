# Coding: UTF-8
require 'sqlite3'

@sqlite = SQLite3::Database.open(@db)

def sqlite_init
  @userConfig[:db_init].each do |com|
    sqlite3(com)
  end
end

def sqlite3(command)
  return @sqlite.execute(command)
rescue SQLite3::BusyException
  retry
end

on_event(:exit) do |object|
  @sqlite.close
end