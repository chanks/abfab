require 'digest/md5'

module ABFab
  module Helpers
    def ab_choose(name)
      result = ABFab.tests[name].value_for(abfab_id)

      yield result if block_given?
      result
    end

    def ab_test(name, &block)
      ABFab.tests[name].add_participant(abfab_id)

      ab_choose(name, &block)
    end

    def fabulous!(*names)
      names.each { |name| ABFab.tests[name].add_conversion(abfab_id) }
    end
  end
end
