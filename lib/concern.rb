class Concern
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  attr_accessor :concerned

  def self.classify(lib)
    lib.split('/').map{|part| part.gsub(/(?:^|_)(.)/){ $1.upcase } }.join('::')
  end

  def self.find_class_from_lib(lib)
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
  
  module ClassMethods
    def concern(lib, options={})
      klass = Concern.find_class_from_lib(lib)

      # make accessor
      accessor = lib.split('/').last.to_sym
      class_eval <<-EOF, __FILE__, __LINE__
        def #{accessor}
          return @#{accessor} if @#{accessor}
          @#{accessor} = #{klass}.new
          @#{accessor}.concerned = self
          @#{accessor}
        end
      EOF

      # call included
      base = eval(name) #self.class is always Class, but name is class that called concern
      klass.included(base) if klass.respond_to? :included

      # delegate methods
      if options[:delegate]
        methods = if options[:delegate].is_a?(Array)
          options[:delegate]
        else
          klass.public_instance_methods(false)
        end

        methods.each do |method|
          class_eval <<-EOF
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