module Fog
  module Network
    class AzureRM
      # Vpn Client Root Certificate model class for Network Service
      class VpnClientRootCertificate < Fog::Model
        attribute :name
        attribute :id
        attribute :public_cert_data
        attribute :provisioning_state

        def self.parse(root_cert)
          hash = {}
          hash['name'] = root_cert['name']
          hash['id'] = root_cert['id']
          hash['public_cert_data'] = root_cert['properties']['publicCertData']
          hash['provisioning_state'] = root_cert['properties']['provisioningState']
          hash
        end
      end
    end
  end
end
