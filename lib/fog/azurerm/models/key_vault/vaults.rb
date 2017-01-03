module Fog
  module KeyVault
    class AzureRM
      # This class is giving implementation of all/list and get for key vault.
      class Vaults < Fog::Collection
        attribute :resource_group
        model Fog::KeyVault::AzureRM::Vault

        def all
          requires :resource_group
          vaults = service.list_vaults(resource_group).map { |vault| Fog::KeyVault::AzureRM::Vault.parse(vault) }
          load(vaults)
        end

        def get(resource_group, vault_name)
          vault = service.get_vault(resource_group, vault_name)
          vault_obj = Fog::KeyVault::AzureRM::Vault.new(service: service)
          vault_obj.merge_attributes(Fog::KeyVault::AzureRM::Vault.parse(vault))
        end

        def check_vault_exists?(resource_group, vault_name)
          service.check_vault_exists?(resource_group, vault_name)
        end
      end
    end
  end
end
