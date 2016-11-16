module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of all/get for Recovery Vaults
      class RecoveryVaults < Fog::Collection
        model Fog::Storage::AzureRM::RecoveryVault
        attribute :resource_group
        attribute :name

        def all
          requires :resource_group
          recovery_vaults = []
          service.list_recovery_vaults(resource_group).each do |recovery_vault|
            recovery_vaults << Fog::Storage::AzureRM::RecoveryVault.parse(recovery_vault)
          end
          load(recovery_vaults)
        end

        def get(resource_group, name)
          recovery_vault = service.get_recovery_vault(resource_group, name)
          recovery_vault_fog = Fog::Storage::AzureRM::RecoveryVault.new(service: service)
          recovery_vault_fog.merge_attributes(Fog::Storage::AzureRM::RecoveryVault.parse(recovery_vault))
        end
      end
    end
  end
end
