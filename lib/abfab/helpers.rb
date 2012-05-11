require 'digest/md5'

module ABFab
  module Helpers
    def ab_choose(test_name)
      result = ABFab.tests[test_name].get_result(abfab_id)

      yield result if block_given?

      result
    end

    def ab_test(test_name, &block)
      ABFab.tests[test_name].add_participant(abfab_id)

      ab_choose(test_name, &block)
    end

    def fabulous!(test_name)
      ABFab.tests[test_name].add_conversion(abfab_id)
    end
  end
end
