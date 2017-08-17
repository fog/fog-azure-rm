module Fog
  module DataLakeStore
    class AzureRM
      # Key Vault Meta Info class for Data Lake Store Account Service
      class KeyVaultMetaInfo < Fog::Model
        attribute :key_vault_resource_id
        attribute :encryption_key_name
        attribute :encryption_key_version

        def self.parse(key_vault_meta_info)
          get_hash_from_object(key_vault_meta_info)
        end
      end
    end
  end
end
