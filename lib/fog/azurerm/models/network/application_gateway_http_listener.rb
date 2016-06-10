module Fog
  module Network
    class AzureRM
      # Http Listener class for Network Service
      class ApplicationGatewayHttpListener < Fog::Model
        identity :name
        attribute :frontendIp
        attribute :frontendPort
        attribute :protocol
        attribute :hostName
        attribute :sslCert
        attribute :requireServerNameIndication

        def self.parse(http_listener)
          http_listener_properties = http_listener['properties']
          hash = {}
          hash['name'] = http_listener['name']
          unless http_listener_properties.nil?
            hash['frontendIp'] = http_listener_properties['frontendIPConfiguration']['id']
            hash['frontendPort'] = http_listener_properties['frontendPort']['id']
            hash['protocol'] = http_listener_properties['protocol']
            hash['hostName'] = http_listener_properties['hostName']
            unless http_listener_properties['sslCertificate'].nil?
              hash['sslCert'] = http_listener_properties['sslCertificate']['id']
              hash['requireServerNameIndication'] = http_listener_properties['sslCertificate']['requireServerNameIndication']
            end
          end
          hash
        end
      end
    end
  end
end
