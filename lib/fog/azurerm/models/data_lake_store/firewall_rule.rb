module Fog
  module DataLakeStore
    class AzureRM
      # Key Vault Meta Info class for Data Lake Store Account Service
      class FirewallRule < Fog::Model
        attribute :name
        attribute :start_ip_address
        attribute :end_ip_address

        def self.parse(firewall_rule)
          hash = get_hash_from_object(firewall_rule)
          hash
        end
      end
    end
  end
end
