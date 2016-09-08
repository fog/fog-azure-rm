module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_local_network_gateway(local_network_gateway_params)
          msg = "Creating/Updating Local Network Gateway: #{local_network_gateway_params[:name]} in Resource Group: #{local_network_gateway_params[:resource_group]}."
          Fog::Logger.debug msg
          local_network_gateway = get_local_network_gateway_parameters(local_network_gateway_params)
          begin
            local_network_gateway = @network_client.local_network_gateways.create_or_update(local_network_gateway_params[:resource_group], local_network_gateway_params[:name], local_network_gateway)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Local Network Gateway #{local_network_gateway_params[:name]} created/updated successfully."
          local_network_gateway
        end

        private

        def get_local_network_gateway_parameters(local_network_gateway_params)
          local_network_gateway = Azure::ARM::Network::Models::LocalNetworkGateway.new

          if local_network_gateway_params[:local_network_address_space_prefixes]
            local_network_gateway.local_network_address_space = get_local_network_address_space(local_network_gateway_params[:local_network_address_space_prefixes])
          end
          local_network_gateway.gateway_ip_address = local_network_gateway_params[:gateway_ip_address] if local_network_gateway_params[:gateway_ip_address]
          local_network_gateway.bgp_settings = get_bgp_settings(local_network_gateway_params)

          local_network_gateway.name = local_network_gateway_params[:name]
          local_network_gateway.type = local_network_gateway_params[:type]
          local_network_gateway.location = local_network_gateway_params[:location]
          local_network_gateway.tags = local_network_gateway_params[:tags] if local_network_gateway.tags.nil?
          local_network_gateway.provisioning_state = local_network_gateway_params[:provisioning_state]

          local_network_gateway
        end

        def get_local_network_address_space(local_network_address_space_prefixes)
          address_space = Azure::ARM::Network::Models::AddressSpace.new
          address_space.address_prefixes = local_network_address_space_prefixes
          address_space
        end

        def get_bgp_settings(local_network_gateway_params)
          bgp_settings = Azure::ARM::Network::Models::BgpSettings.new
          bgp_settings.asn = local_network_gateway_params[:asn]
          bgp_settings.bgp_peering_address = local_network_gateway_params[:bgp_peering_address]
          bgp_settings.peer_weight = local_network_gateway_params[:peer_weight]
          bgp_settings
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_virtual_network_gateway(*)
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
