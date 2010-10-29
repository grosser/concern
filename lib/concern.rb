class Concern
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  attr_accessor :concerned

  def self.classify(lib)
    lib.split('/').map{|part| part.gsub(/(?:^|_)(.)/){ $1.upcase } }.join('::')
  end

  def self.class_from_lib(lib)
    lib = lib.to_s
    klass = Concern.classify(lib)
    begin
      klass = eval(klass)
    rescue
      require lib
      klass = eval(klass)
    end

    unless klass.instance_methods.map{|x|x.to_s}.include?('concerned=')
      raise "A concern must always extend Concern"
    end
    klass
  end

  def self.add_accessor_for_concern(concerned, accessor, concern)
    concerned.class_eval <<-EOF, __FILE__, __LINE__
      def #{accessor}
        return @#{accessor} if @#{accessor}
        @#{accessor} = #{concern}.new
        @#{accessor}.concerned = self
        @#{accessor}
      end
    EOF
  end
  
  module ClassMethods
    def concern(lib, options={})
      concern = Concern.class_from_lib(lib)
      accessor = lib.split('/').last.to_sym

      Concern.add_accessor_for_concern(self, accessor, concern)

      # tell the concern it was included
      concerned = eval(name) #self.class is always Class, but name is class that called concern
      concern.included(concerned) if concern.respond_to? :included

      # delegate methods calls to the concern
      if options[:delegate]
        methods_to_delegate = if options[:delegate].is_a?(Array)
          options[:delegate]
        else
          concern.public_instance_methods(false)
        end

        methods_to_delegate.each do |method|
          class_eval <<-EOF, __FILE__, __LINE__
            def #{method}(*args, &block)
              #{accessor}.send(:#{method}, *args, &block)
            end
          EOF
        end
      end
    end
  end
end

Object.send(:extend, Concern::ClassMethods)