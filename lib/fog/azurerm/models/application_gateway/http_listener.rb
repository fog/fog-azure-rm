module Fog
  module ApplicationGateway
    class AzureRM
      # Http Listener class for Application Gateway Service
      class HttpListener < Fog::Model
        identity :name
        attribute :frontend_ip_config_id
        attribute :frontend_port_id
        attribute :protocol
        attribute :host_name
        attribute :ssl_certificate_id
        attribute :require_server_name_indication

        def self.parse(http_listener)
          http_listener_properties = http_listener['properties']
          hash = {}
          hash['name'] = http_listener['name']
          unless http_listener_properties.nil?
            unless http_listener_properties['frontendIPConfiguration'].nil?
              hash['frontend_ip_config_id'] = http_listener_properties['frontendIPConfiguration']['id']
            end
            unless http_listener_properties['frontendPort'].nil?
              hash['frontend_port_id'] = http_listener_properties['frontendPort']['id']
            end
            hash['protocol'] = http_listener_properties['protocol']
            hash['host_name'] = http_listener_properties['hostName']
            unless http_listener_properties['sslCertificate'].nil?
              hash['ssl_certificate_id'] = http_listener_properties['sslCertificate']['id']
              hash['require_server_name_indication'] = http_listener_properties['sslCertificate']['requireServerNameIndication']
            end
          end
          hash
        end
      end
    end
  end
end
