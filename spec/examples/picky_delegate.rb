$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'
class A
  concern 'a/b', :delegate=>[:test]
end

ok = begin
  A.new.test2
  false
rescue
  true
end
raise unless ok
print A.new.test