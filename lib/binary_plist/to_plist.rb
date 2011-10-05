require 'active_record'
require 'plist'

BinaryPlist::Encoding::SUPPORTED_CLASSES.push ActiveRecord::Base

ActiveRecord::Base.class_eval <<-RUBY, __FILE__, __LINE__
  def to_plist_node
    h = self.serializable_hash
    x = h.delete_if { |k,v| v.nil? }
    Plist::Emit.plist_node(x)
  end
  def to_bplist_node
    h = self.serializable_hash
    x = h.delete_if { |k,v| v.nil? }
  end
RUBY

BinaryPlist::Encoding::SUPPORTED_CLASSES.each do |klass|
  klass.class_eval <<-RUBY, __FILE__, __LINE__
    def to_bplist(options = nil)
      BinaryPlist.encode(self, options)
    end

    def to_plist(options = nil)
      Plist::Emit.dump(self)
    end
  RUBY
end
