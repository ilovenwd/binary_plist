require 'plist'

BinaryPlist::Encoding::SUPPORTED_CLASSES.each do |klass|
  klass.class_eval <<-RUBY, __FILE__, __LINE__
    def to_bplist(options = nil)
      BinaryPlist.encode(self, options)
    end

    def to_plist(options = nil)
	  Plist::Emit.dump(self.as_json)
    end
  RUBY
end
