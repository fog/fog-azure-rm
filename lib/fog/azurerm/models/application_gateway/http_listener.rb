module Fog
  module ApplicationGateway
    class AzureRM
      # Http Listener class for Application Gateway Service
      class HttpListener < Fog::Model
        identity :name
        attribute :id
        attribute :frontend_ip_config_id
        attribute :frontend_port_id
        attribute :protocol
        attribute :host_name
        attribute :ssl_certificate_id
        attribute :require_server_name_indication

        def self.parse(http_listener)
          hash = {}
          hash['id'] = http_listener.id
          hash['name'] = http_listener.name
          hash['frontend_ip_config_id'] = http_listener.frontend_ipconfiguration.id unless http_listener.frontend_ipconfiguration.nil?
          hash['frontend_port_id'] = http_listener.frontend_port.id unless http_listener.frontend_port.nil?
          hash['protocol'] = http_listener.protocol
          hash['host_name'] = http_listener.host_name
          hash['ssl_certificate_id'] = http_listener.ssl_certificate.id unless http_listener.ssl_certificate.nil?
          hash['require_server_name_indication'] = http_listener.require_server_name_indication
          hash
        end
      end
    end
  end
end
