module Fog
  module DataLakeStore
    class AzureRM
      # Key Vault Meta Info class for Data Lake Store Account Service
      class KeyVaultMetaInfo < Fog::Model
        attribute :key_vault_resource_id
        attribute :encryption_key_name
        attribute :encryption_key_version

        def self.parse(key_vault_meta_info)
          hash = {}
          hash['key_vault_resource_id'] = key_vault_meta_info.key_vault_resource_id
          hash['encryption_key_name'] = key_vault_meta_info.encryption_key_name
          hash['encryption_key_version'] = key_vault_meta_info.encryption_key_version
          hash
        end
      end
    end
  end
end
