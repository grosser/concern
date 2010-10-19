$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  module Bc
    class DefGh < Concern
      def test
        'SUCCESS'
      end
    end
  end
  concern 'a/bc/def_gh', :delegate=>true
end

print A.new.test