module Fog
  module KeyVault
    class AzureRM
      # This class is giving implementation of all/list and get for key vault.
      class Vaults < Fog::Collection
        attribute :resource_group
        model Vault

        def all
          requires :resource_group
          vaults = service.list_vaults(resource_group).map { |vault| Vault.parse(vault) }
          load(vaults)
        end

        def get(resource_group, vault_name)
          vault = service.get_vault(resource_group, vault_name)
          vault_obj = Vault.new(service: service)
          vault_obj.merge_attributes(Vault.parse(vault))
        end
      end
    end
  end
end
