module Fog
  module Network
    class AzureRM
      # Real class for Local Network Gateway Request
      class Real
        def create_or_update_local_network_gateway(local_network_gateway_params)
          msg = @logger_messages['network']['local_network_gateway']['message']['create']
                .gsub('NAME', local_network_gateway_params[:name])
                .gsub('RESOURCE_GROUP', local_network_gateway_params[:resource_group])
          Fog::Logger.debug msg
          local_network_gateway = get_local_network_gateway_object(local_network_gateway_params)
          begin
            local_network_gateway = @network_client.local_network_gateways.create_or_update(local_network_gateway_params[:resource_group], local_network_gateway.name, local_network_gateway)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Local Network Gateway #{local_network_gateway_params[:name]} created/updated successfully."
          local_network_gateway
        end

        private

        def get_local_network_gateway_object(local_network_gateway_params)
          local_network_gateway = Azure::Network::Profiles::Latest::Mgmt::Models::LocalNetworkGateway.new
          local_network_gateway.local_network_address_space = get_local_network_address_space_object(local_network_gateway_params[:local_network_address_space_prefixes]) if local_network_gateway_params[:local_network_address_space_prefixes]
          local_network_gateway.gateway_ip_address = local_network_gateway_params[:gateway_ip_address] if local_network_gateway_params[:gateway_ip_address]
          local_network_gateway.bgp_settings = get_bgp_settings_object(local_network_gateway_params)
          local_network_gateway.name = local_network_gateway_params[:name]
          local_network_gateway.type = local_network_gateway_params[:type]
          local_network_gateway.location = local_network_gateway_params[:location]
          local_network_gateway.tags = local_network_gateway_params[:tags] if local_network_gateway.tags.nil?
          local_network_gateway.provisioning_state = local_network_gateway_params[:provisioning_state]
          local_network_gateway.tags = local_network_gateway_params[:tags]
          local_network_gateway
        end

        def get_local_network_address_space_object(local_network_address_space_prefixes)
          address_space = Azure::Network::Profiles::Latest::Mgmt::Models::AddressSpace.new
          address_space.address_prefixes = local_network_address_space_prefixes
          address_space
        end

        def get_bgp_settings_object(local_network_gateway_params)
          bgp_settings = Azure::Network::Profiles::Latest::Mgmt::Models::BgpSettings.new
          bgp_settings.asn = local_network_gateway_params[:asn]
          bgp_settings.bgp_peering_address = local_network_gateway_params[:bgp_peering_address]
          bgp_settings.peer_weight = local_network_gateway_params[:peer_weight]
          bgp_settings
        end
      end

      # Mock class for Local Network Gateway Request
      class Mock
        def create_or_update_virtual_network_gateway(*)
          local_network_gateway = {
            'id' => '/subscriptions/<Subscription_id>/resourceGroups/learn_fog/providers/Microsoft.Network/localNetworkGateways/testLocalNetworkGateway',
            'name' => 'testLocalNetworkGateway',
            'type' => 'Microsoft.Network/localNetworkGateways',
            'location' => 'eastus',
            'properties' =>
              {
                'local_network_address_space' => {
                  'address_prefixes' => []
                },
                'gateway_ip_address' => '192.168.1.1',
                'bgp_settings' => {
                  'asn' => 100,
                  'bgp_peering_address' => '192.168.1.2',
                  'peer_weight' => 3
                }
              }
          }
          local_network_gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::LocalNetworkGateway.mapper
          @network_client.deserialize(local_network_gateway_mapper, local_network_gateway, 'result.body')
        end
      end
    end
  end
end
