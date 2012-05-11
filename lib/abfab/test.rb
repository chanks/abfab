module ABFab
  class Test
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def possibilities(input = nil)
      if input
        @possibilities =
          case input
            when Integer
              (1..input).to_a
            when Hash
              input.inject [] do |array, (key, integer)|
                array += [key.to_s] * integer
              end.sort
            else
              input.to_a
          end
      else
        @possibilities ||= [true, false]
      end
    end

    def key
      "ABFab:#{name}"
    end
  end
end
