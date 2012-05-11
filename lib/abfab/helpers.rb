require 'digest/md5'

module ABFab
  module Helpers
    def ab_choose(test_name)
      test = ABFab.tests[test_name]
      user = abfab_id

      digest = Digest::MD5.hexdigest(user.to_s + test_name.to_s)
      index  = digest.hex % test.possibilities.length
      result = test.possibilities[index]

      yield result if block_given?
      result
    end

    def ab_test(test_name)
      result = ab_choose(test_name)
      test   = ABFab.tests[test_name]
      user   = abfab_id

      ABFab.redis.sadd("#{test.key}:#{result}:participants", user)

      yield result if block_given?
      result
    end

    def fabulous!(test_name)
      test   = ABFab.tests[test_name]
      result = ab_choose(test_name)
      user   = abfab_id

      if ABFab.redis.sismember("#{test.key}:#{result}:participants", user)
        ABFab.redis.sadd("#{test.key}:#{result}:conversions", user)
      end
    end
  end
end
