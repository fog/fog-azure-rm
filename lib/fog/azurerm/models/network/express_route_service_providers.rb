module Fog
  module Network
    class AzureRM
      # ExpressRouteServiceProvider collection class for Network Service
      class ExpressRouteServiceProviders < Fog::Collection
        model ExpressRouteServiceProvider

        def all
          express_route_service_providers = []
          service.list_express_route_service_providers.each do |service_provider|
            express_route_service_providers << ExpressRouteServiceProvider.parse(service_provider)
          end
          load(express_route_service_providers)
        end
      end
    end
  end
end
