# Module for API Stub
module ApiStub
  module Models
    module Compute
      autoload :Server, File.expand_path('../api_stub/models/compute/server', __FILE__)
      autoload :AvailabilitySet, File.expand_path('../api_stub/models/compute/availability_set', __FILE__)
    end

    module Resources
      autoload :ResourceGroup, File.expand_path('../api_stub/models/resources/resource_group', __FILE__)
      autoload :Deployment, File.expand_path('../api_stub/models/resources/deployment', __FILE__)
      autoload :Resource, File.expand_path('../api_stub/models/resources/resource', __FILE__)
    end

    module Storage
      autoload :StorageAccount, File.expand_path('../api_stub/models/storage/storageaccount', __FILE__)
      autoload :Blob, File.expand_path('../api_stub/models/storage/blob', __FILE__)
      autoload :Container, File.expand_path('../api_stub/models/storage/container', __FILE__)
    end

    module Network
      autoload :PublicIp, File.expand_path('../api_stub/models/network/public_ip', __FILE__)
      autoload :Subnet, File.expand_path('../api_stub/models/network/subnet', __FILE__)
      autoload :VirtualNetwork, File.expand_path('../api_stub/models/network/virtual_network', __FILE__)
      autoload :NetworkInterface, File.expand_path('../api_stub/models/network/network_interface', __FILE__)
      autoload :LoadBalancer, File.expand_path('../api_stub/models/network/load_balancer', __FILE__)
      autoload :NetworkSecurityGroup, File.expand_path('../api_stub/models/network/network_security_group', __FILE__)
      autoload :VirtualNetworkGateway, File.expand_path('../api_stub/models/network/virtual_network_gateway', __FILE__)
      autoload :ExpressRouteCircuit, File.expand_path('../api_stub/models/network/express_route_circuit', __FILE__)
      autoload :ExpressRouteCircuitPeering, File.expand_path('../api_stub/models/network/express_route_circuit_peering', __FILE__)
      autoload :ExpressRouteServiceProvider, File.expand_path('../api_stub/models/network/express_route_service_provider', __FILE__)
    end

    module ApplicationGateway
      autoload :Gateway, File.expand_path('../api_stub/models/application_gateway/gateway', __FILE__)
    end

    module TrafficManager
      autoload :TrafficManagerEndPoint, File.expand_path('../api_stub/models/traffic_manager/traffic_manager_end_point', __FILE__)
      autoload :TrafficManagerProfile, File.expand_path('../api_stub/models/traffic_manager/traffic_manager_profile', __FILE__)
    end

    module DNS
      autoload :Zone, File.expand_path('../api_stub/models/dns/zone', __FILE__)
      autoload :RecordSet, File.expand_path('../api_stub/models/dns/record_set', __FILE__)
    end
  end

  module Requests
    module Compute
      autoload :AvailabilitySet, File.expand_path('../api_stub/requests/compute/availability_set', __FILE__)
      autoload :VirtualMachine, File.expand_path('../api_stub/requests/compute/virtual_machine', __FILE__)
    end

    module Resources
      autoload :ResourceGroup, File.expand_path('../api_stub/requests/resources/resource_group', __FILE__)
      autoload :Deployment, File.expand_path('../api_stub/requests/resources/deployment', __FILE__)
      autoload :AzureResource, File.expand_path('../api_stub/requests/resources/resource', __FILE__)
    end

    module Storage
      autoload :StorageAccount, File.expand_path('../api_stub/requests/storage/storageaccount', __FILE__)
      autoload :Blob, File.expand_path('../api_stub/requests/storage/blob', __FILE__)
      autoload :Container, File.expand_path('../api_stub/requests/storage/container', __FILE__)
    end

    module Network
      autoload :PublicIp, File.expand_path('../api_stub/requests/network/public_ip', __FILE__)
      autoload :Subnet, File.expand_path('../api_stub/requests/network/subnet', __FILE__)
      autoload :VirtualNetwork, File.expand_path('../api_stub/requests/network/virtual_network', __FILE__)
      autoload :NetworkInterface, File.expand_path('../api_stub/requests/network/network_interface', __FILE__)
      autoload :LoadBalancer, File.expand_path('../api_stub/requests/network/load_balancer', __FILE__)
      autoload :NetworkSecurityGroup, File.expand_path('../api_stub/requests/network/network_security_group', __FILE__)
      autoload :VirtualNetworkGateway, File.expand_path('../api_stub/requests/network/virtual_network_gateway', __FILE__)
      autoload :ExpressRouteCircuit, File.expand_path('../api_stub/requests/network/express_route_circuit', __FILE__)
      autoload :ExpressRouteCircuitPeering, File.expand_path('../api_stub/requests/network/express_route_circuit_peering', __FILE__)
      autoload :ExpressRouteServiceProvider, File.expand_path('../api_stub/requests/network/express_route_service_provider', __FILE__)
    end

    module ApplicationGateway
      autoload :Gateway, File.expand_path('../api_stub/requests/application_gateway/gateway', __FILE__)
    end

    module TrafficManager
      autoload :TrafficManagerEndPoint, File.expand_path('../api_stub/requests/traffic_manager/traffic_manager_endpoint', __FILE__)
      autoload :TrafficManagerProfile, File.expand_path('../api_stub/requests/traffic_manager/traffic_manager_profile', __FILE__)
    end

    module DNS
      autoload :Zone, File.expand_path('../api_stub/requests/dns/zone', __FILE__)
      autoload :RecordSet, File.expand_path('../api_stub/requests/dns/record_set', __FILE__)
    end
  end
end