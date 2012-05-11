require 'digest/md5'

module ABFab
  module Helpers
    def ab_choose(test_name)
      test = ABFab.tests[test_name]
      user = abfab_id

      digest = Digest::MD5.hexdigest(user.to_s + test_name.to_s)
      index  = digest.hex % test.possibilities.length

      test.possibilities[index]
    end
  end
end
