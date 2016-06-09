module Fog
  module Network
    class AzureRM
      # Backend Http Settings model class for Network Service
      class BackendHttpSetting < Fog::Model
        identity :name
        attribute :port
        attribute :protocol
        attribute :cookieBasedAffinity
        attribute :requestTimeout
        attribute :probe

        def self.parse(backend_http_setting)
          backend_http_setting_properties = backend_http_setting['properties']

          hash = {}
          hash['name'] = backend_http_setting['name']
          unless backend_http_setting_properties.nil?
            hash['port'] = backend_http_setting_properties['port']
            hash['protocol'] = backend_http_setting_properties['protocol']
            hash['cookieBasedAffinity'] = backend_http_setting_properties['cookieBasedAffinity']
            hash['requestTimeout'] = backend_http_setting_properties['requestTimeout']
            hash['probe'] = backend_http_setting_properties['probe']
            hash
          end
        end
      end
    end
  end
end
