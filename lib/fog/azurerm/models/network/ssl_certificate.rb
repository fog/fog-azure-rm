module Fog
  module Network
    class AzureRM
      # SSL Certificate model class for Network Service
      class SslCertificate < Fog::Model
        identity :name
        attribute :data
        attribute :password
        attribute :publicCertData

        def self.parse(ssl_certificate)
          ssl_certificate_properties = ssl_certificate['properties']

          hash = {}
          hash['name'] = ssl_certificate['name']
          unless ssl_certificate_properties.nil?
            hash['data'] = ssl_certificate_properties['data']
            hash['password'] = ssl_certificate_properties['password']
            hash['publicCertData'] = ssl_certificate_properties['publicCertData']
          end
          hash
        end
      end
    end
  end
end
