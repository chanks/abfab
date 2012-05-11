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

    def get_result(user)
      digest = Digest::MD5.hexdigest(user.to_s + name.to_s)

      index = digest.hex % possibilities.length

      possibilities[index]
    end

    def add_participant(user)
      result = get_result user
      key    = key_for result, :participants

      ABFab.redis.sadd key, user
    end

    def add_conversion(user)
      result = get_result(user)

      participant_key = key_for result, :participants
      conversion_key  = key_for result, :conversions

      if ABFab.redis.sismember(participant_key, user)
        ABFab.redis.sadd(conversion_key, user)
      end
    end

    def key_for(*args)
      ["ABFab", name, *args].join(':')
    end
  end
end
