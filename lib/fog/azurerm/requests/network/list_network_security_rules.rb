module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_security_rules(resource_group, network_security_group_name)
          msg = "Getting list of Network Security Rule in Security Group #{network_security_group_name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg

          begin
            nsr_list_result = @network_client.security_rules.list_as_lazy(resource_group, network_security_group_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Rules list retrieved successfully from Resource Group #{resource_group}."
          nsr_list_result.value
        end
      end

      # Mock class for Network Security Rule Request
      class Mock
        def list_network_security_rules(*)
          nsr_list = '{
            "value":[
              {
                "name":"myNsRule",
                "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNsg/securityRules/myNsRule",
                "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                "properties":{
                  "provisioningState":"Succeeded",
                  "description":"description-of-this-rule",
                  "protocol": "*",
                  "sourcePortRange":"source-port-range",
                  "destinationPortRange":"destination-port-range",
                  "sourceAddressPrefix":"*",
                  "destinationAddressPrefix":"*",
                  "access":"Allow",
                  "priority":100,
                  "direction":"Inbound"
                }
              }
          ]
          }'
          nsr_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::SecurityRuleListResult.mapper
          @network_client.deserialize(nsr_mapper, JSON.load(nsr_list), 'result.body')
        end
      end
    end
  end
end
