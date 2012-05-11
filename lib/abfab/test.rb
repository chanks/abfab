module ABFab
  class Test
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def possibilities(array = nil)
      if array
        @possibilities = array
      else
        @possibilities
      end
    end
  end
end
