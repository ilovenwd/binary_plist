require 'plist'

module BinaryPlist
  module BinaryPlistResponder
    def to_format
      BinaryPlist.encode resource
    end
  end
end

module Plist
  module PlistResponder
    def to_format
	  Plist::Emit.dump resource.as_json
    end
  end
end
