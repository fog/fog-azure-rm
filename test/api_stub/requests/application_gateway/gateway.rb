module ApiStub
  module Requests
    module ApplicationGateway
      # Mock class for Application Gateway Requests
      class Gateway
        def self.create_application_gateway_response(gateway_client)
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
          gateway_mapper = Azure::ARM::Network::Models::ApplicationGateway.mapper
          gateway_client.deserialize(gateway_mapper, JSON.load(response), 'result.body')
        end

        def self.gateway_params
          gateway_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.gateway_ip_configurations
          frontend_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ip_configurations
          frontend_ports = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ports
          backend_address_pools = ApiStub::Requests::ApplicationGateway::Gateway.backend_address_pools
          backend_http_settings_list = ApiStub::Requests::ApplicationGateway::Gateway.backend_http_settings_list
          http_listeners = ApiStub::Requests::ApplicationGateway::Gateway.http_listeners
          request_routing_rules = ApiStub::Requests::ApplicationGateway::Gateway.request_routing_rules
          params = {
            name: 'gateway',
            location: 'East US',
            resource_group: 'fogRM-rg',
            sku_name: 'Standard_Medium',
            sku_tier: 'Standard',
            sku_capacity: 2,
            gateway_ip_configurations: gateway_ip_configurations,
            ssl_certificates: ssl_certificates,
            frontend_ip_configurations: frontend_ip_configurations,
            frontend_ports: frontend_ports,
            probes: probes,
            backend_address_pools: backend_address_pools,
            backend_http_settings_list: backend_http_settings_list,
            http_listeners: http_listeners,
            url_path_maps: url_path_maps,
            request_routing_rules: request_routing_rules
          }
          params
        end

        def self.list_application_gateway_response(gateway_client)
          response = '{
	          "value": [{
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
            }]
          }'
          gateway_list_mapper = Azure::ARM::Network::Models::ApplicationGatewayListResult.mapper
          gateway_client.deserialize(gateway_list_mapper, JSON.load(response), 'result.body')
        end

        def self.delete_application_gateway_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end

        def self.gateway_ip_configurations
          gateway_ip_config =
            [
              {
                name: 'gatewayIpConfigName',
                subnet_id: '/subscriptions/{guid}/resourcegroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnetName'
              }
            ]
          gateway_ip_config
        end

        def self.ssl_certificates
          certificates =
            [
              {
                name: 'certificate',
                data: 'data',
                password: '123',
                public_cert_data: 'MIIDiDCCAnACCQCwYkR0Mxy+QTANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCUEsxDzANBgNVBAgTBlB1bmphYjEPMA0GA1UEBxMGTGFob3JlMQ8wDQYDVQQKEwZDb25maXoxDDAKBgNVBAsTA0RldjEPMA0GA1UEAxMGaGFpZGVyMSQwIgYJKoZIhvcNAQkBFhVoYWlkZXIuYWxpQGNvbmZpei5jb20wHhcNMTYwMzAyMTE0NTM2WhcNMTcwMzAyMTE0NTM2WjCBhTELMAkGA1UEBhMCUEsxDzANBgNVBAgTBlB1bmphYjEPMA0GA1UEBxMGTGFob3JlMQ8wDQYDVQQKEwZDb25maXoxDDAKBgNVBAsTA0RldjEPMA0GA1UEAxMGaGFpZGVyMSQwIgYJKoZIhvcNAQkBFhVoYWlkZXIuYWxpQGNvbmZpei5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCuJrPbvOG+4oXQRamkOALlpdK98m+atJue9zOcCCagY8IJI4quYL13d8VItmrZf7erA+siqpYlWEuk1+lmmUY7T4AWAL8mXeR2vc7hWF601WDUjeVPK19+IcC8emMLOlBpvjXC9nbvADLQuR0PGitfjCqFoG66EOqJmLDNBsyHWmy+qhb8J4WXitruNAJDPe/20h6L23vD6z4tvwBjh4zkrfskGlKCNcAuvG1NI0FAS8261Jvs3lf+8oFyI+oSXGtknrkeQv3PbXyeEe3KO5a/M61Uebo04Uwd4yCvdu6H0sF+YYA4bfFdanuFmrZvf9cZSwknQid+vOdzyGkTHTPFAgMBAAEwDQYJKoZIhvcNAQEFBQADggEBAKtPhYpfvn5OxP+BcChsWaQA4KZQj0THGdiAjHsvfjsgteFvhkzqZBkhKYtsAWV5tB5/GDl+o4c6PQJ2/TXhOJn3pSNaUzrCJIGtKS5DknbqTQxCwVlxyBtPHLAYWqKcPMlH282rw3VY0OYTL96XOgZ/WZjcN6A7ku+uWsNCql443FoWL+N3Gpaab45OyIluFUOH+yc0ToHNlP3iOpI3rVpi2xwmGrSyUKsGUma3nrBq7TWjkDE1E+oJoybaMNZzgXGIPSJC1HYIF1U8GSoFkZpAFxXecD0FinXWDRwUP6K54iti3i6a/Ox73WhwfI4mVCqsOy1WYWtKYhMVe6Kj4Nw='
              }
            ]
          certificates
        end

        def self.frontend_ip_configurations
          frontend_ip_config =
            [
              {
                name: 'frontendIpConfig',
                private_ip_allocation_method: 'Dynamic',
                public_ip_address_id: '/subscriptions/{guid}/resourcegroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/publicIp',
                private_ip_address: '10.0.1.5'
              }
            ]
          frontend_ip_config
        end

        def self.frontend_ports
          ports =
            [
              {
                name: 'frontendPort',
                port: 443
              }
            ]
          ports
        end

        def self.probes
          probes =
            [
              {
                name: 'probe1',
                protocol: 'tcp',
                host: 'localhost',
                path: '/usr/',
                interval: 30,
                timeout: 20,
                unhealthy_threshold: 20
              }
            ]
          probes
        end

        def self.backend_address_pools
          address_pool =
            [
              {
                name: 'backendAddressPool',
                ip_addresses: [
                  {
                    ipAddress: '10.0.1.6'
                  }
                ]
              }
            ]
          address_pool
        end

        def self.backend_http_settings_list
          http_setting =
            [
              {
                name: 'gateway_settings',
                port: 80,
                protocol: 'Http',
                cookie_based_affinity: 'Enabled',
                request_timeout: '30',
                probe: ''
              }
            ]
          http_setting
        end

        def self.http_listeners
          listener =
            [
              {
                name: 'gateway_listener',
                frontend_ip_config_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendIPConfigurations/frontend_ip_config',
                frontend_port_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/frontendPorts/gateway_front_port',
                protocol: 'Https',
                host_name: '',
                ssl_certificate_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/sslCertificates/ssl_certificate',
                require_server_name_indication: 'false'
              }
            ]
          listener
        end

        def self.url_path_maps
          path_map =
            [
              {
                name: 'map1',
                default_backend_address_pool_id: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool',
                default_backend_http_settings_id: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings',
                path_rules: [
                  {
                    backend_address_pool_id: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool',
                    backend_http_settings_id: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings',
                    paths: [
                      %w(/usr /etc)
                    ]
                  }
                ]
              }
            ]
          path_map
        end

        def self.request_routing_rules
          routing_rule =
            [
              {
                name: 'gateway_request_route_rule',
                type: 'Basic',
                http_listener_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/httpListeners/gateway_listener',
                backend_address_pool_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool',
                backend_http_settings_id: '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings',
                url_path_map: ''
              }
            ]
          routing_rule
        end
      end
    end
  end
end
