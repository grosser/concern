$LOAD_PATH << 'lib'
require 'concern'

class A
  class B < Concern
    def test
      yield
    end
  end
  concern 'a/b', :delegate => [:test]
end

print A.new.test{ "SUCCESS" }
