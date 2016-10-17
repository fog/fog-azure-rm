module Fog
  module ApplicationGateway
    class AzureRM
      # Application Gateway collection class for Application Gateway Service
      class Gateways < Fog::Collection
        model Gateway
        attribute :resource_group

        def all
          requires :resource_group
          application_gateways = []
          service.list_application_gateways(resource_group).each do |gateway|
            application_gateways << Gateway.parse(gateway)
          end
          load(application_gateways)
        end

        def get(resource_group_name, application_gateway_name)
          gateway = service.get_application_gateway(resource_group_name, application_gateway_name)
          application_gateway = Gateway.new(service: service)
          application_gateway.merge_attributes(Gateway.parse(gateway))
        end
      end
    end
  end
end
