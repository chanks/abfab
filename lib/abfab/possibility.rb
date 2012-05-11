module ABFab
  class Possibility
    def initialize(test, value)
      @test  = test
      @value = value
    end

    def add_participant(user)
      ABFab.redis.sadd key_for(:participants), user
    end

    def add_conversion(user)
      if ABFab.redis.sismember key_for(:participants), user
        ABFab.redis.sadd key_for(:conversions), user
      end
    end

    private

    def key_for(*things)
      @test.key_for @value, *things
    end
  end
end
