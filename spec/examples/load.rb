$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  concern 'a/b'
end

print A.new.b.test