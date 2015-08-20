def error(ex)
  if ex.message == "User is over daily status update limit."
    text = background_color(text_color(ex.message, :white))
    print "\n#{text}\n"
    exit
  end
  if ex.class.to_s == "Twitter::Error::TooManyRequests"
    text = background_color(text_color(ex.class.to_s, :white))
    print "\n#{text}\n"
    exit
  end
  if ex.message == "failed to create window"
    text = background_color(text_color(ex.message + ". terminal is too small. Please use more 65*15 size.", :white))
    print "\n#{text}\n"
    exit
  end
  if ex.message == "nodename nor servname provided, or not known"
    text = background_color(text_color("No network connection", :white))
    print "\n#{text}\n"
    exit
  end
  if ex.message == "invalid byte sequence in UTF-8"
    text = background_color(text_color("Faild. Please re-type.", :white))
    print "\n#{text}\n"
    return
  end
  if ex.message == "execution expired"
    text = background_color(text_color("Faild:Timeout. Please retry.", :white))
    print "\n#{text}\n"
    return
  end
  if ex.message == "Sorry, that page does not exist."
    text = background_color(text_color("User not found.", :white))
    print "\n#{text}\n"
    return
  end
  text = background_color(text_color(ex.class, :white))
  text1 = background_color(text_color(ex.message, :white))
  text2 = background_color(text_color(ex.backtrace, :white))
  print "\n#{text}\n#{text1}\n#{text2}\n"
end