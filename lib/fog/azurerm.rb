require 'ms_rest_azure'
require 'rest_client'
require 'erb'
require 'fog/azurerm/config'
require 'fog/azurerm/utilities/general'
require 'fog/azurerm/version'
require 'fog/core'

module Fog
  module Credentials
    autoload :AzureRM, File.expand_path('azurerm/credentials', __dir__)
  end
  module Compute
    autoload :AzureRM, File.expand_path('azurerm/compute', __dir__)
  end
  module DNS
    autoload :AzureRM, File.expand_path('azurerm/dns', __dir__)
  end
  module Network
    autoload :AzureRM, File.expand_path('azurerm/network', __dir__)
  end
  module Resources
    autoload :AzureRM, File.expand_path('azurerm/resources', __dir__)
  end
  module TrafficManager
    autoload :AzureRM, File.expand_path('azurerm/traffic_manager', __dir__)
  end
  module Storage
    autoload :AzureRM, File.expand_path('azurerm/storage', __dir__)
  end
  module ApplicationGateway
    autoload :AzureRM, File.expand_path('azurerm/application_gateway', __dir__)
  end

  # Main AzureRM fog Provider Module
  module AzureRM
    extend Fog::Provider
    service(:resources, 'Resources')
    service(:dns, 'DNS')
    service(:storage, 'Storage')
    service(:network, 'Network')
    service(:compute, 'Compute')
    service(:application_gateway, 'ApplicationGateway')
    service(:traffic_manager, 'TrafficManager')
  end
end
