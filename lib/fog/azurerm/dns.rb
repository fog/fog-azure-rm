module Fog
  module DNS
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/dns'
      request :create_or_update_zone
      request :delete_zone
      request :check_for_zone
      request :list_zones
      request :get_zone
      request :create_or_update_record_set
      request :delete_record_set
      request :list_record_sets
      request :get_records_from_record_set
      request :get_record_set

      model_path 'fog/azurerm/models/dns'
      model :zone
      collection :zones
      model :record_set
      collection :record_sets

      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
        end
      end

      # This class provides the actual implementation for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_dns'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @dns_client = ::Azure::ARM::Dns::DnsManagementClient.new(credentials)
          @dns_client.subscription_id = options[:subscription_id]
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @resources = Fog::Resources::AzureRM.new(
            tenant_id: options[:tenant_id],
            client_id: options[:client_id],
            client_secret: options[:client_secret],
            subscription_id: options[:subscription_id]
          )
        end
      end
    end
  end
end
