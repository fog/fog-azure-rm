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
          backend_http_setting_properties = backend_http_setting['properties']

          hash = {}
          hash['name'] = backend_http_setting['name']
          unless backend_http_setting_properties.nil?
            hash['port'] = backend_http_setting_properties['port']
            hash['protocol'] = backend_http_setting_properties['protocol']
            hash['cookie_based_affinity'] = backend_http_setting_properties['cookieBasedAffinity']
            hash['request_timeout'] = backend_http_setting_properties['requestTimeout']
            hash['probe'] = backend_http_setting_properties['probe']
            hash
          end
        end
      end
    end
  end
end
