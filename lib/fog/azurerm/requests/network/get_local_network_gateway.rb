module Fog
  module Network
    class AzureRM
      # Real class for Local Network Gateway Request
      class Real
        def get_local_network_gateway(resource_group_name, local_network_gateway_name)
          msg = "Getting Local Network Gateway #{local_network_gateway_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            local_network_gateway = @network_client.local_network_gateways.get(resource_group_name, local_network_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Local Network Gateway #{local_network_gateway_name} retrieved successfully."
          local_network_gateway
        end
      end

      # Mock class for Network Gateway Request
      class Mock
        def get_local_network_gateway(*)
          local_network_gateway = Azure::ARM::Network::Models::LocalNetworkGateway.new
          local_network_gateway.id = '/subscriptions/<Subscription_id>/resourceGroups/learn_fog/providers/Microsoft.Network/localNetworkGateways/testLocalNetworkGateway'
          local_network_gateway.name = 'testLocalNetworkGateway'
          local_network_gateway.type = 'Microsoft.Network/localNetworkGateways'
          local_network_gateway.location = 'eastus'
          local_network_gateway.gateway_ip_address = '192.168.1.1'
          local_network_gateway.provisioning_state = 'Succeeded'
          address_space = Azure::ARM::Network::Models::AddressSpace.new
          address_space.address_prefixes = []
          local_network_gateway.local_network_address_space = address_space
          bgp_settings = Azure::ARM::Network::Models::BgpSettings.new
          bgp_settings.asn = 100
          bgp_settings.bgp_peering_address = '192.168.1.2'
          bgp_settings.peer_weight = 3
          local_network_gateway.bgp_settings = bgp_settings
          local_network_gateway.resource_guid = '########-####-####-####-############'
          local_network_gateway
        end
      end
    end
  end
end
