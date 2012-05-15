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
      digest = Digest::MD5.hexdigest(hash + user.to_s)
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
      ["ABFab", hash, *args].join(':')
    end

    def type # Only type supported right now.
      :g_test
    end

    # A hash that uniquely identifies the test. If anything changes about the
    # test (name, type, values, whatever) the hash changes and the test
    # restarts from scratch. This is to prevent people from modifying tests
    # while they run, which would give them bad results.

    def hash
      raw = [name, type, values.join('/')].join(' ')
      Digest::MD5.hexdigest(raw)
    end

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

    def results
      results = {}

      possibilities.each_value do |possibility|
        participants = ABFab.redis.scard possibility.key_for(:participants)
        conversions  = ABFab.redis.scard possibility.key_for(:conversions)
        results[possibility.value] = [participants, conversions]
      end

      results.map do |value, (participants, conversions)|
        "#{value} had #{participants} participants and #{conversions} conversions"
      end.join("\n")
    end
  end
end
