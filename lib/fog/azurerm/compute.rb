require 'fog/azurerm/core'
# rubocop:disable LineLength
module Fog
  module Compute
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/compute'
      request :create_availability_set
      request :delete_availability_set
      request :list_availability_sets

      model_path 'fog/azurerm/models/compute'
      model :availability_set
      collection :availability_sets
      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_compute'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end
      # This class provides the actual implemention for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_compute'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @compute_mgmt_client = ::Azure::ARM::Compute::ComputeManagementClient.new(credentials)
          @compute_mgmt_client.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
