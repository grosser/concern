$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  def xxx
    'xxx'
  end
  concern 'a/b', :delegate=>true
end

raise if A.new.send(:xxx) != 'xxx'
print A.new.test