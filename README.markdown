Seperation of concerns without meta-madness and namespace pollution.  

Normal includes and extensions pollute the namespace and share private/protected.  
With concern, everything stays in the Concern, can access the concerned and keep namespaced+private.

Install
=======
As Gem: ` sudo gem install grosser-concern -s http://gems.github.com `  
Or as Rails plugin: ` script/plugins install git://github.com/grosser/concern.git `

Usage
=====
Normal usage:
    # a.rb
    require 'concern'
    class A
      concern 'a/acl'

      def admin? ...
    end

    # a/acl.rb
    class A::ACL < Concern
      def can_access?(vault)
        admin? and secret
      end

      private

      def secrect ...
    end

    A.new.acl.can_access?(BankAccount)

Delegate usage:

    class A
      class Message
        def write_message ...
        def read_message ...
      end

      concern 'a/acl', :delegate => true # all public
      concern 'a/messages', :delegate => [:write_message]
    end

    A.new.can_access?(BankAccount)
    A.new.write_message
    A.new.message.read_message

Adding to concerned:
    class A
      class B < Concern
        def initialize
          super
          @something = {}
        end

        def self.included(base)
          base.class_eval do
            test
          end
        end
      end

      def self.test
        puts "it works"
      end

      concern 'a/b'
    end

More examples can be found in [spec/examples](http://github.com/grosser/concern/tree/master/spec/examples)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...