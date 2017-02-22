module Flumtter
  class Window::DMBase < Window::Buf::Element
    def id
      @object.id
    end

    private
    def user
      "#{@object.sender.name} (@#{@object.sender.screen_name})"
    end

    def created_at
      @object.created_at.strftime("%Y/%m/%d %H:%M:%S")
    end

    def header
      "#{@index} ".ljust(width, ?-, "@#{@object.sender.screen_name} => @#{@object.recipient.screen_name}")
    end

    def body
      @object.text.nl
    end

    def footer
      created_at
    end
  end
end
