$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  concern 'a/bc_def_gh', :delegate=>true
end

print A.new.test