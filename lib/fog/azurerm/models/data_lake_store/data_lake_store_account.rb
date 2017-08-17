module Fog
  module DataLakeStore
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Data Lake Store Account.
      class DataLakeStoreAccount < Fog::Model
        attribute :id
        identity :name
        attribute :resource_group
        attribute :location
        attribute :type
        attribute :tags
        attribute :firewall_state
        attribute :firewall_allow_azure_ips
        attribute :firewall_rules
        attribute :encryption_state
        attribute :encryption_config
        attribute :new_tier
        attribute :current_tier

        def self.parse(account)
          hash = get_hash_from_object(account)
          hash['resource_group'] = get_resource_group_from_id(account.id)
          unless account.encryption_config.nil?
            encryption_config = Fog::DataLakeStore::AzureRM::EncryptionConfig.new
            hash['encryption_config'] = encryption_config.merge_attributes(Fog::DataLakeStore::AzureRM::EncryptionConfig.parse(account.encryption_config))
          end
          hash['firewall_rules'] = []
          account.firewall_rules.each do |rule|
            firewall_rule = Fog::DataLakeStore::AzureRM::FirewallRule.new
            hash['firewall_rules'] << firewall_rule.merge_attributes(Fog::DataLakeStore::AzureRM::FirewallRule.parse(rule))
          end unless account.firewall_rules.nil?
          hash
        end

        def save
          requires :name, :resource_group, :location
          account = service.create_data_lake_store_account(data_lake_store_params)
          merge_attributes(Fog::DataLakeStore::AzureRM::DataLakeStoreAccount.parse(account))
        end

        def update(input_hash)
          validate_input(input_hash)
          merge_attributes(input_hash)
          account = service.update_data_lake_store_account(data_lake_store_params)
          merge_attributes(Fog::DataLakeStore::AzureRM::DataLakeStoreAccount.parse(account))
        end

        def destroy
          service.delete_data_lake_store_account(resource_group, name)
        end

        private

        def data_lake_store_params
          {
              name: name,
              resource_group: resource_group,
              location: location,
              type: type,
              tags: tags,
              encryption_state: encryption_state,
              encryption_config: encryption_config,
              firewall_state: firewall_state,
              firewall_allow_azure_ips: firewall_allow_azure_ips,
              firewall_rules: firewall_rules,
              new_tier: new_tier,
              current_tier: current_tier
          }
        end

        def validate_input(input_hash)
          invalid_attr = [:name, :resource_group, :location, :id, :encryption_state, :encryption_config, :current_tier, :firewall_rules]
          result = invalid_attr & input_hash.keys
          raise 'Cannot modify the given attribute' unless result.empty?
        end
      end
    end
  end
end
