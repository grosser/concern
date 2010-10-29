$LOAD_PATH << 'lib'
require 'concern'

class A
  class B < Concern
    def random_method_name
    end
  end
  concern 'a/b', :delegate => [:random_method_name]
end

class C
  class D < Concern
    def random_method_name2
    end
  end
  concern 'c/d', :delegate => true
end

if Object.instance_methods.include?("random_method_name") or Object.instance_methods.include?("random_method_name2")
  print "FAIL"
else
  print "SUCCESS"
end