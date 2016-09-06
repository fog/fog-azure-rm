module Fog
  module Network
    class AzureRM
      # VirtualNetworkGatewayConnection model class for Network Service
      class VirtualNetworkGatewayConnection < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :tags
        attribute :virtual_network_gateway1
        attribute :virtual_network_gateway2
        attribute :local_network_gateway2
        attribute :connection_type
        attribute :connection_status
        attribute :authorization_key
        attribute :routing_weight
        attribute :shared_key
        attribute :egress_bytes_transferred
        attribute :ingress_bytes_transferred
        attribute :peer
        attribute :enable_bgp
        attribute :resource_guid
        attribute :provisioning_state

        def self.parse(gateway_connection)
          connection = {}
          connection['id'] = gateway_connection.id
          connection['name'] = gateway_connection.name
          connection['location'] = gateway_connection.location
          connection['resource_group'] = get_resource_group_from_id(gateway_connection.id)
          connection['tags'] = gateway_connection.tags

          unless gateway_connection.virtual_network_gateway1.nil?
            gateway1 = Fog::Network::AzureRM::VirtualNetworkGateway.new
            hash['virtual_network_gateway1'] = gateway1.merge_attributes(Fog::Network::AzureRM::VirtualNetworkGateway.parse(gateway_connection.virtual_network_gateway1))
          end

          unless gateway_connection.virtual_network_gateway2.nil?
            gateway2 = Fog::Network::AzureRM::VirtualNetworkGateway.new
            hash['virtual_network_gateway2'] = gateway2.merge_attributes(Fog::Network::AzureRM::VirtualNetworkGateway.parse(gateway_connection.virtual_network_gateway2))
          end

          connection['connection_type'] = gateway_connection.connection_type
          connection['connection_status'] = gateway_connection.connection_status
          connection['authorization_key'] = gateway_connection.authorization_key
          connection['routing_weight'] = gateway_connection.routing_weight
          connection['shared_key'] = gateway_connection.shared_key
          connection['egress_bytes_transferred'] = gateway_connection.egress_bytes_transferred
          connection['ingress_bytes_transferred'] = gateway_connection.ingress_bytes_transferred
          connection['peer'] = gateway_connection.peer
          connection['enable_bgp'] = gateway_connection.enable_bgp
          connection['provisioning_state'] = gateway_connection.provisioning_state

          connection
        end

        def save
          requires :name, :location, :resource_group, :connectionType
          gateway_connection_params = gateway_connection_parameters
          gateway_connection = service.create_or_update_virtual_network_gateway_connection(gateway_connection_params)
          merge_attributes(Fog::Network::AzureRM::VirtualNetworkGatewayConnection.parse(gateway_connection))
        end

        def destroy
          service.delete_virtual_network_gateway_connection(resource_group, name)
        end

        private

        def gateway_connection_parameters
          {
              resource_group_name: resource_group,
              name: name,
              location: location,
              tags: tags,
              virtual_network_gateway1: virtual_network_gateway1,
              virtual_network_gateway2: virtual_network_gateway2,
              local_network_gateway2: local_network_gateway2,
              enable_bgp: enable_bgp,
              provisioning_state: provisioning_state,
              connection_type: connection_type,
              connection_status: connection_status,
              authorization_key: authorization_key,
              routing_weight: routing_weight,
              shared_key: shared_key,
              egress_bytes_transferred: egress_bytes_transferred,
              ingress_bytes_transferred: ingress_bytes_transferred,
              peer: peer,
              resource_guid: resource_guid
          }
        end
      end
    end
  end
end
