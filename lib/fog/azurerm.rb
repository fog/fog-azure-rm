require 'ms_rest_azure'
require 'rest_client'
require 'erb'
require 'fog/azurerm/config'
require 'fog/azurerm/utilities/general'
require 'fog/azurerm/version'
require 'fog/azurerm/core'

module Fog
  module Credentials
    autoload :AzureRM, File.expand_path('../azurerm/credentials', __FILE__)
  end
  module Compute
    autoload :AzureRM, File.expand_path('../azurerm/compute', __FILE__)
  end
  module DNS
    autoload :AzureRM, File.expand_path('../azurerm/dns', __FILE__)
  end
  module Network
    autoload :AzureRM, File.expand_path('../azurerm/network', __FILE__)
  end
  module Resources
    autoload :AzureRM, File.expand_path('../azurerm/resources', __FILE__)
  end
  module TrafficManager
    autoload :AzureRM, File.expand_path('../azurerm/traffic_manager', __FILE__)
  end
  module Storage
    autoload :AzureRM, File.expand_path('../azurerm/storage', __FILE__)
  end
  module ApplicationGateway
    autoload :AzureRM, File.expand_path('../azurerm/application_gateway', __FILE__)
  end

  # Main AzureRM fog Provider Module
  module AzureRM
    def self.services
      begin
        array_of_services = []
        ENV['BUNDLE_GEM'] = File.expand_path('../../lib', File.dirname(__FILE__))
        gem_path = ENV['BUNDLE_GEM']
        files = Dir.entries(File.join(gem_path, '/fog/azurerm')).select { |f| !File.directory? f }
        files.each do |file|
          next if file == 'config.rb'
          next if file == 'core.rb'
          next if file == 'credentials.rb'
          next if file == 'docs'
          next if file == 'models'
          next if file == 'requests'
          next if file == 'version.rb'
          array_of_services.push(file.split('.').first.upcase)
        end
        array_of_services
      rescue => e
        Fog::Logger.warning(e.message)
        raise e.message
        # typically occurs if folder_to_count does not exist
      end
    end
  end
end
