module Fog
  module ApplicationGateway
    class AzureRM
      # Backend Http Settings model class for Application Gateway Service
      class BackendHttpSetting < Fog::Model
        identity :name
        attribute :port
        attribute :protocol
        attribute :cookie_based_affinity
        attribute :request_timeout
        attribute :probe

        def self.parse(backend_http_setting)
          hash = {}
          hash['name'] = backend_http_setting.name
          hash['port'] = backend_http_setting.port
          hash['protocol'] = backend_http_setting.protocol
          hash['cookie_based_affinity'] = backend_http_setting.cookie_based_affinity
          hash['request_timeout'] = backend_http_setting.request_timeout
          hash['probe'] = backend_http_setting.probe
          hash
        end
      end
    end
  end
end
