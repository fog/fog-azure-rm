module Fog
  module KeyVault
    class AzureRM
      # Vault model for KeyVault Service
      class Vault < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :vault_uri
        attribute :tenant_id
        attribute :sku_family
        attribute :sku_name
        attribute :access_policies
        attribute :enabled_for_deployment
        attribute :enabled_for_disk_encryption
        attribute :enabled_for_template_deployment
        attribute :tags

        def self.parse(vault)
          vault_hash = get_hash_from_object(vault)
          vault_properties = vault.properties

          unless vault_properties.nil?
            vault_hash['vault_uri'] = vault_properties.vault_uri
            vault_hash['tenant_id'] = vault_properties.tenant_id

            unless vault_properties.sku.nil?
              vault_hash['sku_family'] = vault_properties.sku.family
              vault_hash['sku_name'] = vault_properties.sku.name
            end

            vault_hash['access_policies'] = []
            unless vault_properties.access_policies.nil?
              vault_properties.access_policies.each do |access_policy|
                access_policy_entry = Fog::KeyVault::AzureRM::AccessPolicyEntry.new
                vault_hash['access_policies'] << access_policy_entry.merge_attributes(Fog::KeyVault::AzureRM::AccessPolicyEntry.parse(access_policy))
              end
            end

            vault_hash['enabled_for_deployment'] = vault_properties.enabled_for_deployment
            vault_hash['enabled_for_disk_encryption'] = vault_properties.enabled_for_disk_encryption
            vault_hash['enabled_for_template_deployment'] = vault_properties.enabled_for_template_deployment

            vault_hash['resource_group'] = get_resource_group_from_id(vault.id)
          end

          vault_hash
        end

        def save
          requires :name, :resource_group, :location, :tenant_id, :sku_family, :sku_name, :access_policies
          vault = service.create_or_update_vault(vault_hash)
          merge_attributes(Fog::KeyVault::AzureRM::Vault.parse(vault))
        end

        def destroy
          service.delete_vault(resource_group, name)
        end

        private

        def vault_hash
          {
            resource_group: resource_group,
            name: name,
            location: location,
            tenant_id: tenant_id,
            sku_family: sku_family,
            sku_name: sku_name,
            access_policies: access_policies,
            tags: tags
          }
        end
      end
    end
  end
end
