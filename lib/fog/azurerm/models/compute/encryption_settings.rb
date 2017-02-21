module Fog
  module Compute
    class AzureRM
      # EncryptionSettings model for Compute Service
      class EncryptionSettings < Fog::Model
        attribute :key_url
        attribute :secret_url
        attribute :enabled
        attribute :key_source_vault_id
        attribute :disk_source_vault_id

        def self.parse(encryption_settings)
          settings = {}
          settings['enabled'] = encryption_settings.enabled

          if encryption_settings.disk_encryption_key
            settings['secret_url'] = encryption_settings.disk_encryption_key.secret_url
            settings['disk_source_vault_id'] = encryption_settings.disk_encryption_key.source_vault.id
          end
          if encryption_settings.key_encryption_key
            settings['key_url'] = encryption_settings.key_encryption_key.key_url
            settings['key_source_vault_id'] = encryption_settings.key_encryption_key.source_vault.id
          end
          settings
        end
      end
    end
  end
end