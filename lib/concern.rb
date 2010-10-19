class Concern
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  attr_accessor :concerned

  def self.classify(lib)
    lib.split('/').map{|part| part.gsub(/(?:^|_)(.)/){ $1.upcase } }.join('::')
  end
end

class Object
  def self.concern(lib, options={})
    # load delegate
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

    # make accessor
    accessor = lib.split('/').last.to_sym
    eval <<-EOF
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
        eval <<-EOF
          def #{method}(*args)
            #{accessor}.#{method}(*args)
          end
        EOF
      end
    end
  end
end