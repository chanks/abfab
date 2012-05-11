require 'digest/md5'

module ABFab
  class Test
    attr_reader :name

    def initialize(name)
      @name = name
    end

    # Values is a weighted array of the results of an AB test.
    # Possibilities is a hash of unique values and their Possibility objects.

    # i.e. If you configure ABFab with "values :big => 2, :small => 1":
    # values = ['big', 'big', 'small']
    # possibilities = {'big' => Possibility... 'small' => ABFab::Possibility...}

    def values(input = nil)
      if input
        @possibilities = nil
        @values = case input
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
        @values ||= values([true, false])
      end
    end

    def value_for(user)
      digest = Digest::MD5.hexdigest(user.to_s + name.to_s)
      index  = digest.hex % values.length
      value  = values[index]

      case value
      when NilClass, TrueClass, FalseClass, Symbol, Numeric, Class, Module
        value
      else
        value.dup
      end
    end

    def add_participant(user)
      possibility_for(user).add_participant(user)
    end

    def add_conversion(user)
      possibility_for(user).add_conversion(user)
    end

    def key_for(*args)
      ["ABFab", name, *args].join(':')
    end

    private

    def possibility_for(user)
      possibilities[value_for(user)]
    end

    def possibilities
      @possibilities ||= begin
        hash = {}
        values.each do |value|
          hash[value] ||= ABFab::Possibility.new(self, value)
        end
        hash
      end
    end
  end
end
