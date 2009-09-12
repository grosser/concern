$LOAD_PATH << 'lib'
require 'concern'
class A
  class B < Concern
    def test
      'inline'
    end
  end
  concern 'a/b'
end

print A.new.b.test