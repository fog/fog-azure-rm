module Fog
  module Sql
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id
      recognizes :environment

      request_path 'fog/azurerm/requests/sql'
      request :create_or_update_sql_server
      request :delete_sql_server
      request :get_sql_server
      request :list_sql_servers
      request :check_sql_server_exists?

      request :create_or_update_database
      request :delete_database
      request :get_database
      request :list_databases
      request :check_database_exists?

      request :create_or_update_firewall_rule
      request :delete_firewall_rule
      request :get_firewall_rule
      request :list_firewall_rules
      request :check_firewall_rule_exists?

      model_path 'fog/azurerm/models/sql'
      model :sql_server
      collection :sql_servers

      model :sql_database
      collection :sql_databases

      model :firewall_rule
      collection :firewall_rules

      # This class provides the actual implementation for service calls.
      class Real
        def initialize(options)
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @subscription_id = options[:subscription_id]
          @resources = Fog::Resources::AzureRM.new(
            tenant_id: options[:tenant_id],
            client_id: options[:client_id],
            client_secret: options[:client_secret],
            subscription_id: options[:subscription_id],
            environment: options[:environment]
          )
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
        end
      end
    end
  end
end
