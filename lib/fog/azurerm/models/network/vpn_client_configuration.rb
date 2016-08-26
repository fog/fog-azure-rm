module Fog
  module Network
    class AzureRM
      # Vpn Client Configuration model class for Network Service
      class VpnClientConfiguration < Fog::Model
        attribute :address_pool
        attribute :root_certificates
        attribute :revoked_certificates

        def self.parse(vpn_client_config)
          hash = {}
          hash['address_pool'] = []
          vpn_client_config.vpn_client_address_pool.each do |address_prefix|
            hash['address_pool'] << address_prefix
          end unless vpn_client_config.vpn_client_address_pool.nil?

          hash['root_certificates'] = []
          vpn_client_config.vpn_client_root_certificates.each do |root_cert|
            root_certificate = Fog::Network::AzureRM::VpnClientRootCertificate.new
            hash['root_certificates'] << root_certificate.merge_attributes(Fog::Network::AzureRM::VpnClientRootCertificate.parse(root_cert))
          end unless vpn_client_config.vpn_client_root_certificates.nil?

          hash['revoked_certificates'] = []
          vpn_client_config.vpn_client_revoked_certificates.each do |revoked_cert|
            revoked_certificate = Fog::Network::AzureRM::VpnClientRevokedCertificate.new
            hash['revoked_certificates'] << revoked_certificate.merge_attributes(Fog::Network::AzureRM::VpnClientRevokedCertificate.parse(revoked_cert))
          end unless vpn_client_config.vpn_client_revoked_certificates.nil?

          hash
        end
      end
    end
  end
end
