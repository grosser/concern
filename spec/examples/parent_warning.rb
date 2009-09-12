$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  class B # < Concern
  end

  begin
    concern 'a/b'
    print 'FAIL'
  rescue
    raise unless $!.to_s =~ /extend Concern/
    print 'SUCCESS'
  end
end