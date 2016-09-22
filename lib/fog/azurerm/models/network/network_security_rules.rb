require 'fog/core/collection'
require 'fog/azurerm/models/network/network_security_rule'

module Fog
  module Network
    class AzureRM
      # collection class for Network Security Rule
      class NetworkSecurityRules < Fog::Collection
        model Fog::Network::AzureRM::NetworkSecurityRule
        attribute :resource_group
        attribute :network_security_group_name

        def all
          requires :resource_group
          requires :network_security_group_name
          network_security_rules = []
          service.list_network_security_rules(resource_group, network_security_group_name).each do |nsr|
            network_security_rules << NetworkSecurityRule.parse(nsr)
          end
          load(network_security_rules)
        end

        def get(resource_group, network_security_group_name, name)
          network_security_rule = service.get_network_security_rule(resource_group, network_security_group_name, name)
          network_security_rule_obj = NetworkSecurityRule.new(service: service)
          network_security_rule_obj.merge_attributes(NetworkSecurityRule.parse(network_security_rule))
        end
      end
    end
  end
end
