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
          connection = get_hash_from_object(gateway_connection)

          unless gateway_connection.virtual_network_gateway1.nil?
            gateway1 = VirtualNetworkGateway.new
            connection['virtual_network_gateway1'] = gateway1.merge_attributes(VirtualNetworkGateway.parse(gateway_connection.virtual_network_gateway1))
          end

          unless gateway_connection.virtual_network_gateway2.nil?
            gateway2 = VirtualNetworkGateway.new
            connection['virtual_network_gateway2'] = gateway2.merge_attributes(VirtualNetworkGateway.parse(gateway_connection.virtual_network_gateway2))
          end
          connection['resource_group'] = get_resource_group_from_id(gateway_connection.id)
          connection
        end

        def save
          requires :name, :location, :resource_group, :connection_type
          gateway_connection_params = gateway_connection_parameters
          gateway_connection = service.create_or_update_virtual_network_gateway_connection(gateway_connection_params)
          merge_attributes(VirtualNetworkGatewayConnection.parse(gateway_connection))
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
            connection_type: connection_type,
            authorization_key: authorization_key,
            routing_weight: routing_weight,
            shared_key: shared_key,
            egress_bytes_transferred: egress_bytes_transferred,
            ingress_bytes_transferred: ingress_bytes_transferred,
            peer: peer
          }
        end
      end
    end
  end
end
