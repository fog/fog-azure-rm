require "fog/azurerm/core"

module Fog
  module DNS
    class AzureRM < Fog::Service
      requires  :tenant_id
      requires  :client_id
      requires  :client_secret
      requires  :subscription_id

      request_path "fog/azurerm/requests/dns"
      request :create_zone
      request :delete_zone
      request :list_zones

      model_path "fog/azurerm/models/dns"
      model :zone
      collection :zones

      class Mock
        def initialize(options={})
          begin
            require "fog/azurerm/libraries/dns/zone"
            require "fog/azurerm/libraries/dns/token"
          rescue LoadError => e
            retry if require("rubygems")
            raise e.message
          end
        end
      end

      class Real
        def initialize(options)
          begin
            require "fog/azurerm/libraries/dns/zone"
            require "fog/azurerm/libraries/dns/token"
          rescue LoadError => e
            retry if require("rubygems")
            raise e.message
          end
          @token = ::Fog::DNS::Libraries::Token.new(options[:tenant_id], options[:client_id], options[:client_secret])
          token = @token.generate_token
          @zone = ::Fog::DNS::Libraries::Zone.new(options[:subscription_id], token)
          @resources = Fog::Resources::AzureRM.new(
             :tenant_id => options[:tenant_id],
             :client_id =>    options[:client_id],
             :client_secret => options[:client_secret],
             :subscription_id => options[:subscription_id]
           )
        end
      end
    end
  end
end