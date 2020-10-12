require 'ms_rest_azure'
require 'azure/core/http/http_error'
require 'erb'
require 'fog/azurerm/config'
require 'fog/azurerm/constants'
require 'fog/azurerm/utilities/general'
require 'fog/azurerm/version'
require 'fog/core'
require 'fog/json'
require 'fog/azurerm/models/compute/caching_types'
require 'fog/azurerm/models/compute/disk_create_option_types'
require 'fog/azurerm/models/network/ipallocation_method'
require 'fog/azurerm/models/network/security_rule_access'
require 'fog/azurerm/models/network/security_rule_direction'
require 'fog/azurerm/models/network/security_rule_protocol'
require 'fog/azurerm/models/storage/sku_name'
require 'fog/azurerm/models/storage/sku_tier'
require 'fog/azurerm/models/storage/kind'

module Fog
  # Autoload Module for Credentials
  module Credentials
    autoload :AzureRM, File.expand_path('azurerm/credentials', __dir__)
  end

  # Autoload Module for Compute
  module Compute
    autoload :AzureRM, File.expand_path('azurerm/compute', __dir__)
  end

  # Autoload Module for DNS
  module DNS
    autoload :AzureRM, File.expand_path('azurerm/dns', __dir__)
  end

  # Autoload Module for Network
  module Network
    autoload :AzureRM, File.expand_path('azurerm/network', __dir__)
  end

  # Autoload Module for Resources
  module Resources
    autoload :AzureRM, File.expand_path('azurerm/resources', __dir__)
  end

  # Autoload Module for TrafficManager
  module TrafficManager
    autoload :AzureRM, File.expand_path('azurerm/traffic_manager', __dir__)
  end

  # Autoload Module for Storage
  module Storage
    autoload :AzureRM, File.expand_path('azurerm/storage', __dir__)
  end

  # Autoload Module for ApplicationGateway
  module ApplicationGateway
    autoload :AzureRM, File.expand_path('azurerm/application_gateway', __dir__)
  end

  # Autoload Module for Sql
  module Sql
    autoload :AzureRM, File.expand_path('azurerm/sql', __dir__)
  end

  # Autoload Module for KeyVault
  module KeyVault
    autoload :AzureRM, File.expand_path('azurerm/key_vault', __dir__)
  end

  # Autoload Module for Response::Asynchronous
  module AzureRM
    autoload :AsyncResponse, File.expand_path('azurerm/async_response', __dir__)
  end

  # Main AzureRM fog Provider Module
  module AzureRM
    # We cannot necessarily set the DEBUG environment variable for fog-azure-rm because
    # that would log the complete HTTP body since this variable is also used by the Azure storage SDK.
    # Instead let's offer another way to enable fog-azure-rm debug logging
    Fog::Logger[:debug] = ::STDERR if ENV["FOG_DEBUG"]
    extend Fog::Provider
    service(:resources, 'Resources')
    service(:dns, 'DNS')
    service(:storage, 'Storage')
    service(:network, 'Network')
    service(:compute, 'Compute')
    service(:application_gateway, 'ApplicationGateway')
    service(:traffic_manager, 'TrafficManager')
    service(:sql, 'Sql')
    service(:key_vault, 'KeyVault')
  end
end
