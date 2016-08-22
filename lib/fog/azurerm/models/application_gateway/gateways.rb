require 'fog/core/collection'
require 'fog/azurerm/models/application_gateway/gateway'

module Fog
  module ApplicationGateway
    class AzureRM
      # Application Gateway collection class for Application Gateway Service
      class Gateways < Fog::Collection
        model Fog::ApplicationGateway::AzureRM::Gateway
        attribute :resource_group

        def all
          requires :resource_group
          application_gateways = []
          service.list_application_gateways(resource_group).each do |gateway|
            application_gateways << Fog::ApplicationGateway::AzureRM::Gateway.parse(gateway)
          end
          load(application_gateways)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
