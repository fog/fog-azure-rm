module Fog
  module ApplicationGateway
    class AzureRM
      # SSL Certificate model class for Application Gateway Service
      class SslCertificate < Fog::Model
        identity :name
        attribute :data
        attribute :password
        attribute :public_cert_data

        def self.parse(ssl_certificate)
          hash = {}
          hash['name'] = ssl_certificate.name
          hash['data'] = ssl_certificate.data
          hash['password'] = ssl_certificate.password
          hash['public_cert_data'] = ssl_certificate.public_cert_data
          hash
        end
      end
    end
  end
end
