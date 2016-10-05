require 'fog/core/collection'
require 'fog/azurerm/models/storage/recovery_vault'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of all/get for Recovery Vaults
      class RecoveryVaults < Fog::Collection
        model RecoveryVault
        attribute :resource_group
        attribute :name

        def all
          requires :resource_group
          recovery_vaults = []
          service.list_recovery_vaults(resource_group).each do |recovery_vault|
            recovery_vaults << RecoveryVault.parse(recovery_vault)
          end
          load(recovery_vaults)
        end

        def get(resource_group, name)
          recovery_vault = service.get_recovery_vault(resource_group, name)
          recovery_vault_obj = RecoveryVault.new(service: service)
          recovery_vault_obj.merge_attributes(RecoveryVault.parse(recovery_vault))
        end
      end
    end
  end
end