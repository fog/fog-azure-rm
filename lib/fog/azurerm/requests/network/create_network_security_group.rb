module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_network_security_group(resource_group, name, location, security_rules)
          Fog::Logger.debug "Creating Network Security Group #{name} in Resource Group #{resource_group}."
          properties = Azure::ARM::Network::Models::NetworkSecurityGroupPropertiesFormat.new
          properties.security_rules = define_security_rules(security_rules)

          params = Azure::ARM::Network::Models::NetworkSecurityGroup.new
          params.location = location
          params.properties = properties
          begin
            promise = @network_client.network_security_groups.begin_create_or_update(resource_group, name, params)
            result = promise.value!
            Fog::Logger.debug "Network Security Group #{name} Created Successfully!"
            Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Network Security Group #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def define_security_rules(security_rules)
          rules = []
          security_rules.each do |sr|
            properties = Azure::ARM::Network::Models::SecurityRulePropertiesFormat.new
            properties.description = sr[:description] unless sr[:description].nil?
            properties.protocol = sr[:protocol]
            properties.source_port_range = sr[:source_port_range]
            properties.destination_port_range = sr[:destination_port_range]
            properties.source_address_prefix = sr[:source_address_prefix]
            properties.destination_address_prefix = sr[:destination_address_prefix]
            properties.access = sr[:access]
            properties.priority = sr[:priority]
            properties.direction = sr[:direction]

            security_rule = Azure::ARM::Network::Models::SecurityRule.new
            security_rule.name = sr[:name]
            security_rule.properties = properties
            rules << security_rule
          end unless security_rules.nil?
          rules
        end
      end

      # Mock class for Network Request
      class Mock
        def create_network_security_group(_resource_group, _name, _location, _security_rules)
        end
      end
    end
  end
end
