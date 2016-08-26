module Fog
  module ApplicationGateway
    class AzureRM
      # Frontenf Port model class for Application Gateway Service
      class FrontendPort < Fog::Model
        identity :name
        attribute :port

        def self.parse(frontend_port)
          hash = {}
          hash['name'] = frontend_port.name
          hash['port'] = frontend_port.port unless frontend_port.port.nil?
          hash
        end
      end
    end
  end
end
