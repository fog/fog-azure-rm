require 'fog/azurerm/core'
require 'fog/azurerm/credentials'

module Fog
  module DNS
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/dns'
      request :create_zone
      request :delete_zone
      request :list_zones
      request :create_record_set
      request :delete_record_set
      request :list_record_sets
      request :get_records_from_record_set

      model_path 'fog/azurerm/models/dns'
      model :zone
      collection :zones
      model :record_set
      collection :record_sets

      class Mock
        def initialize(options = {})
        end
      end

      class Real
        def initialize(options)
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @subscription_id = options[:subscription_id]
          token = Fog::Credentials::AzureRM.get_token(options[:tenant_id], options[:client_id], options[:client_secret])
          @resources = Fog::Resources::AzureRM.new(
              tenant_id: options[:tenant_id],
              client_id: options[:client_id],
              client_secret: options[:client_secret],
              subscription_id: options[:subscription_id])
        end
      end
    end
  end
end
