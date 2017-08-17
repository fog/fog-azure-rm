module Fog
  module DataLakeStore
    class AzureRM
      # Encryption Config class for Data Lake Store Account Service
      class EncryptionConfig < Fog::Model
        attribute :type
        attribute :key_vault_meta_info

        def self.parse(encryption_config)
          hash = {}
          hash['type'] = encryption_config.type
          unless encryption_config.key_vault_meta_info.nil?
            key_vault_meta_info = Fog::DataLakeStore::AzureRM::KeyVaultMetaInfo.new
            hash['key_vault_meta_info'] = key_vault_meta_info.merge_attributes(Fog::DataLakeStore::AzureRM::KeyVaultMetaInfo.parse(encryption_config.key_vault_meta_info))
          end
          hash
        end
      end
    end
  end
end
