module Fog
  module Network
    class AzureRM
      # Vpn Client Revoked Certificate model class for Network Service
      class VpnClientRevokedCertificate < Fog::Model
        attribute :name
        attribute :id
        attribute :thumbprint
        attribute :provisioning_state

        def self.parse(revoked_cert)
          hash = {}
          hash['name'] = revoked_cert['name']
          hash['id'] = revoked_cert['id']
          hash['thumbprint'] = revoked_cert['properties']['thumbprint']
          hash['provisioning_state'] = revoked_cert['properties']['provisioningState']
          hash
        end
      end
    end
  end
end
