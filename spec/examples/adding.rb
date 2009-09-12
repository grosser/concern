$LOAD_PATH << 'lib' << 'spec/examples'
require 'concern'

class A
  class B < Concern
    def initialize
      super
      @hello = 'world'
    end

    def hello
      @hello
    end

    def self.included(base)
      base.class_eval do
        test
      end
    end
  end

  def self.test
    print "yep"
  end

  concern 'a/b'
end

print A.new.b.hello