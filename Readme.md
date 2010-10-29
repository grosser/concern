Seperation of concerns with clean namespaces.  

Normal includes and extensions pollute the namespace and share private/protected.  
With concern, everything stays in the Concern, can access the concerned and keep namespaced+private.

Install
=======
 - As Rails plugin: `rails plugin install git://github.com/grosser/concern.git `
 - As gem: ` gem install concern `

Usage
=====
Simple:
    # a.rb
    require 'concern'
    class A
      concern 'a/acl'

      def admin? ...
    end

    # a/acl.rb
    # can access concerned methods like `admin?`
    class A::ACL < Concern
      def can_access?(vault)
        admin? and secret
      end

      private

      def secrect ...
    end

    A.new.acl.can_access?(BankAccount)

Let no outsider know, and use delegate:

    class A
      class Messages
        def write ...
        def read ...
      end

      concern 'a/acl', :delegate => true # delegate all public methods
      concern 'a/messages', :delegate => [:write]
    end

    A.new.can_access?(BankAccount) # no more `.acl` needed
    A.new.write
    A.new.messages.read

Adding to the concerned, e.g. validations/associations/scopes etc.
    class User < ActiveRecord::Base
      concern 'user/validator', :delegate => true
    end

    # user/validator.rb
    class User::Validator < Concern
      def self.included(concerned)
        concerned.class_eval do
          validates_presence_of :name, :if => :name_seems_legit?
        end
      end

      def name_seems_legit? ..
    end

More examples can be found in [spec/examples](http://github.com/grosser/concern/tree/master/spec/examples)

Authors
=======

### [Contributors](http://github.com/grosser/concern/contributors)
 - [Colin Curtin](http://github.com/perplexes)

[Michael Grosser](http://grosser.it)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...