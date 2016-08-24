require 'ms_rest_azure'
require 'rest_client'
require 'erb'
require 'fog/azurerm/config'
require 'fog/azurerm/utilities/general'
require 'fog/azurerm/version'
require 'fog/azurerm/core'
require 'fog/azurerm/dns'
require 'fog/azurerm/fog_azure_rm_exception'
require 'fog/azurerm/resources'
require 'fog/azurerm/storage'
require 'fog/azurerm/network'
require 'fog/azurerm/compute'
require 'fog/azurerm/traffic_manager'

module Fog
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
