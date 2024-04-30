module Fog
  module Network
    class AzureRM
      # Network Security Group model for Network Service
      class NetworkSecurityGroup < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :network_interfaces_ids
        attribute :subnets_ids
        attribute :security_rules
        attribute :default_security_rules
        attribute :tags

        def self.parse(nsg)
          hash = {}
          hash['id'] = nsg.id
          hash['name'] = nsg.name
          hash['resource_group'] = get_resource_from_resource_id(nsg.id, RESOURCE_GROUP_NAME)
          hash['location'] = nsg.location
          hash['network_interfaces_ids'] = nsg.network_interfaces.map(&:id) unless nsg.network_interfaces.nil?
          hash['subnets_ids'] = nsg.subnets.map(&:id) unless nsg.subnets.nil?
          hash['security_rules'] = []
          hash['default_security_rules'] = []
          hash['tags'] = nsg.tags

          nsg.security_rules.each do |sr|
            security_rule = Fog::Network::AzureRM::NetworkSecurityRule.new
            hash['security_rules'] << security_rule.merge_attributes(Fog::Network::AzureRM::NetworkSecurityRule.parse(sr))
          end unless nsg.security_rules.nil?

          nsg.default_security_rules.each do |dsr|
            security_rule = Fog::Network::AzureRM::NetworkSecurityRule.new
            hash['default_security_rules'] << security_rule.merge_attributes(Fog::Network::AzureRM::NetworkSecurityRule.parse(dsr))
          end

          hash
        end

        def save
          requires :name, :location, :resource_group

          security_rules_to_hashes!
          validate_security_rules(security_rules) unless security_rules.nil?
          nsg = service.create_or_update_network_security_group(resource_group, name, location, security_rules, tags)
          merge_attributes(Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg))
        end

        def destroy
          service.delete_network_security_group(resource_group, name)
        end

        def update_security_rules(security_rule_hash = {})
          raise('Provided hash can not be empty.') if security_rule_hash.empty? || security_rule_hash.nil?

          if !security_rule_hash[:security_rules].nil? && security_rule_hash.length == 1
            validate_security_rules(security_rule_hash[:security_rules])
            merge_attributes(security_rule_hash)
            nsg = service.create_or_update_network_security_group(resource_group, name, location, security_rules, tags)
            return merge_attributes(Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg))
          end
          raise 'Invalid hash key.'
        end

        def add_security_rules(security_rules)
          validate_security_rules(security_rules)
          nsg = service.add_security_rules(resource_group, name, security_rules)
          merge_attributes(Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg))
        end

        def remove_security_rule(security_rule_name)
          nsg = service.remove_security_rule(resource_group, name, security_rule_name)
          merge_attributes(Fog::Network::AzureRM::NetworkSecurityGroup.parse(nsg))
        end

        private

        def security_rules_to_hashes!
          return unless security_rules.is_a? Array

          self.security_rules = security_rules.map do |rule|
            if rule.is_a? NetworkSecurityRule
              get_hash_from_object(rule)['attributes']
            else
              rule
            end
          end
        end

        def validate_security_rules(security_rules)
          if security_rules.is_a?(Array)
            security_rules.each do |sr|
              if sr.is_a?(Hash)
                validate_security_rule_params(sr)
              else
                raise(ArgumentError, 'Parameter security_rules must be an Array of Hashes')
              end
            end
          else
            raise(ArgumentError, 'Parameter security_rules must be an Array')
          end
        end

        def validate_security_rule_params(nsr)
          required_params = [
            :name,
            :protocol,
            :source_port_range,
            :destination_port_range,
            :source_address_prefix,
            :destination_address_prefix,
            :access,
            :priority,
            :direction
          ]
          missing = required_params.select { |p| p unless nsr.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end
      end
    end
  end
end
