module Fog
  module Network
    class AzureRM
      # Frontenf Port model class for Network Service
      class ApplicationGatewayFrontendPort < Fog::Model
        identity :name
        attribute :port

        def self.parse(frontend_port)
          frontend_port_properties = frontend_port['properties']

          hash = {}
          hash['name'] = frontend_port['name']
          unless frontend_port_properties['port'].nil?
            hash['port'] = frontend_port_properties['port']
          end
          hash
        end
      end
    end
  end
end
