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

    # a.rb
    class A
      class Message
        def write_message ...
        def read_message ...
      end

      concern 'a/acl', :delegate => :true # all public
      concern 'a/messages', :delegate => [:write_message]
    end

    A.new.can_access?(BankAccount)
    A.new.write_message
    A.new.message.read_message

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...