module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def get_application_gateway(resource_group_name, application_gateway_name)
          msg = "Getting Application Gateway: #{application_gateway_name} in Resource group: #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            application_gateway = @network_client.application_gateways.get(resource_group_name, application_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting application gateway #{application_gateway_name} successfully in Resource Group: #{resource_group_name}"
          application_gateway
        end
      end

      # Mock class for Application Gateway Request
      class Mock
        def get_application_gateway(*)
          response = '{
            "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway",
            "name": "gateway",
            "type": "Microsoft.Network/applicationGateways",
            "location": "eastus",
            "properties": {
              "sku": {
                "name": "Standard_Medium",
                "tier": "Standard",
                "capacity": 2
              },
              "gatewayIPConfigurations": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/gatewayIPConfigurations/ag-GatewayIP",
                  "properties": {
                    "subnet": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/vnet/subnets/GatewaySubnet"
                    },
                    "provisioningState": "Succeeded"
                  },
                  "name": "ag-GatewayIP"
                }
              ],
              "sslCertificates": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/sslCertificates/ssl_certificate",
                  "properties": {
                    "publicCertData": "MIIDiDCCAnACCQCwYkR0Mxy+QTANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCUEsxDzANBgNVBAgTBlB1bmphYjEPMA0GA1UEBxMGTGFob3JlMQ8wDQYDVQQKEwZDb25maXoxDDAKBgNVBAsTA0RldjEPMA0GA1UEAxMGaGFpZGVyMSQwIgYJKoZIhvcNAQkBFhVoYWlkZXIuYWxpQGNvbmZpei5jb20wHhcNMTYwMzAyMTE0NTM2WhcNMTcwMzAyMTE0NTM2WjCBhTELMAkGA1UEBhMCUEsxDzANBgNVBAgTBlB1bmphYjEPMA0GA1UEBxMGTGFob3JlMQ8wDQYDVQQKEwZDb25maXoxDDAKBgNVBAsTA0RldjEPMA0GA1UEAxMGaGFpZGVyMSQwIgYJKoZIhvcNAQkBFhVoYWlkZXIuYWxpQGNvbmZpei5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCuJrPbvOG+4oXQRamkOALlpdK98m+atJue9zOcCCagY8IJI4quYL13d8VItmrZf7erA+siqpYlWEuk1+lmmUY7T4AWAL8mXeR2vc7hWF601WDUjeVPK19+IcC8emMLOlBpvjXC9nbvADLQuR0PGitfjCqFoG66EOqJmLDNBsyHWmy+qhb8J4WXitruNAJDPe/20h6L23vD6z4tvwBjh4zkrfskGlKCNcAuvG1NI0FAS8261Jvs3lf+8oFyI+oSXGtknrkeQv3PbXyeEe3KO5a/M61Uebo04Uwd4yCvdu6H0sF+YYA4bfFdanuFmrZvf9cZSwknQid+vOdzyGkTHTPFAgMBAAEwDQYJKoZIhvcNAQEFBQADggEBAKtPhYpfvn5OxP+BcChsWaQA4KZQj0THGdiAjHsvfjsgteFvhkzqZBkhKYtsAWV5tB5/GDl+o4c6PQJ2/TXhOJn3pSNaUzrCJIGtKS5DknbqTQxCwVlxyBtPHLAYWqKcPMlH282rw3VY0OYTL96XOgZ/WZjcN6A7ku+uWsNCql443FoWL+N3Gpaab45OyIluFUOH+yc0ToHNlP3iOpI3rVpi2xwmGrSyUKsGUma3nrBq7TWjkDE1E+oJoybaMNZzgXGIPSJC1HYIF1U8GSoFkZpAFxXecD0FinXWDRwUP6K54iti3i6a/Ox73WhwfI4mVCqsOy1WYWtKYhMVe6Kj4Nw=",
                    "provisioningState": "Succeeded"
                  },
                  "name": "ssl_certificate"
                }
              ],
              "frontendIPConfigurations": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendIPConfigurations/frontend_ip_config",
                  "properties": {
                    "privateIPAllocationMethod": "Dynamic",
                    "publicIPAddress": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/ag_publicip-672835"
                    },
                    "provisioningState": "Succeeded"
                  },
                  "name": "frontend_ip_config"
                }
              ],
              "frontendPorts": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendPorts/gateway_front_port",
                  "properties": {
                    "port": 443,
                    "provisioningState": "Succeeded"
                  },
                  "name": "gateway_front_port"
                }
              ],
              "probes": [],
              "backendAddressPools": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool",
                  "properties": {
                    "backendAddresses": [
                      {
                        "ipAddress": "10.0.0.4"
                      },
                      {
                        "ipAddress": "10.0.0.5"
                      }
                    ],
                    "provisioningState": "Succeeded"
                  },
                  "name": "AG-BackEndAddressPool"
                }
              ],
              "backendHttpSettingsCollection": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings",
                  "properties": {
                    "port": 80,
                    "protocol": "Http",
                    "cookieBasedAffinity": "Enabled",
                    "requestTimeout": 30,
                    "provisioningState": "Succeeded"
                  },
                  "name": "gateway_settings"
                }
              ],
              "httpListeners": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/httpListeners/gateway_listener",
                  "properties": {
                    "frontendIPConfiguration": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendIPConfigurations/frontend_ip_config"
                    },
                    "frontendPort": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendPorts/gateway_front_port"
                    },
                    "protocol": "Https",
                    "sslCertificate": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/sslCertificates/ssl_certificate"
                    },
                    "requireServerNameIndication": false,
                    "provisioningState": "Succeeded"
                  },
                  "name": "gateway_listener"
                }
              ],
              "urlPathMaps": [],
              "requestRoutingRules": [
                {
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/requestRoutingRules/gateway_request_route_rule",
                  "properties": {
                    "ruleType": "Basic",
                    "backendAddressPool": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool"
                    },
                    "backendHttpSettings": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings"
                    },
                    "httpListener": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/httpListeners/gateway_listener"
                    },
                    "provisioningState": "Succeeded"
                  },
                  "name": "gateway_request_route_rule"
                }
              ],
              "resourceGuid": "b3db5ebf-10f8-4666-9596-d1459530f64b",
              "provisioningState": "Succeeded"
            }
          }'
          gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGateway.mapper
          @network_client.deserialize(gateway_mapper, JSON.load(response), 'result.body')
        end
      end
    end
  end
end
