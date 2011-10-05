require 'binary_plist'
require 'plist'

module BinaryPlist
  autoload :BinaryPlistResponder, 'binary_plist/responder'
  
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'binary_plist.add_plist_responder' do
        if defined? Mongoid
          BinaryPlist::Railtie.insert
        else
          ActiveSupport.on_load :active_record do
            BinaryPlist::Railtie.insert
          end
        end
      end
    end
  end

  class Railtie
    def self.insert
      Mime::Type.register BinaryPlist::MIME_TYPE, :bplist
      Mime::Type.register Plist::MIME_TYPE, :plist
      
      ActionController::Renderers.add :bplist do |data, options|
        data = data.as_json(options)
      
        self.content_type ||= Mime::BPLIST
        self.response_body = BinaryPlist.encode(data)
      end

      ActionController::Renderers.add :plist do |data, options|
        data = data.as_json(options)

        self.content_type ||= Mime::PLIST
        self.response_body = Plist::Emit.dump(data)
      end
    end
  end
end
