module Fog
  module Network
    class AzureRM
      # Express Route Circuit Authorization model class for Network Service
      class ExpressRouteCircuitAuthorization < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :authorization_name
        attribute :authorization_key
        attribute :authorization_status
        attribute :provisioning_state
        attribute :etag
        attribute :circuit_name

        def self.parse(circuit_authorization)
          circuit_auth_hash = {}
          circuit_auth_hash['id'] = circuit_authorization.id
          circuit_auth_hash['resource_group'] = get_resource_group_from_id(circuit_authorization.id)
          circuit_auth_hash['circuit_name'] = get_circuit_name_from_id(circuit_authorization.id)
          circuit_auth_hash['authorization_key'] = circuit_authorization.authorization_key
          circuit_auth_hash['authorization_status'] = circuit_authorization.authorization_use_status
          circuit_auth_hash['provisioning_state'] = circuit_authorization.provisioning_state
          circuit_auth_hash['name'] = circuit_authorization.name
          circuit_auth_hash['etag'] = circuit_authorization.etag

          circuit_auth_hash
        end

        def save
          requires :name, :resource_group, :circuit_name
          circuit_authorization_parameters = express_route_circuit_authorization_params
          circuit_authorization = service.create_or_update_express_route_circuit_authorization(circuit_authorization_parameters)
          merge_attributes(ExpressRouteCircuitAuthorization.parse(circuit_authorization))
        end

        def destroy
          service.delete_express_route_circuit_authorization(resource_group, circuit_name, name)
        end

        private

        def express_route_circuit_authorization_params
          {
            name: name,
            resource_group: resource_group,
            circuit_name: circuit_name,
            authorization_name: authorization_name,
            authorization_key: authorization_key,
            authorization_status: authorization_status,
            provisioning_state: provisioning_state,
            etag: etag
          }
        end
      end
    end
  end
end
