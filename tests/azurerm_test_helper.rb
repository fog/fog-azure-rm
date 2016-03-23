def azurerm_resources_service
  Fog::Resources::AzureRM.new
end

def azurerm_dns_service
  Fog::DNS::AzureRM.new
end

def rg_attributes
  {
      :name => rg_name,
      :location => location
  }
end

def rg_name
  "fog-test-resource-group"
end

def zone_name
  "fogtestzone.com"
end

def  location
  "West US"
end

def fog_resource_group
  resource_group = azurerm_resources_service.resource_groups.select { |rg| rg.name == rg_name }.first
  unless resource_group
    resource_group = azurerm_resources_service.resource_groups.create(
        rg_attributes
    )
  end
  resource_group
end

def fog_zone
  zone = azurerm_dns_service.zones.select { |z| z.name == zone_name && z.resource_group == rg_name}.first
  unless zone
    zone = azurerm_dns_service.zones.create(
        {:name => zone_name, :resource_group => rg_name}
    )
  end
  zone
end

def rg_destroy
  resource_group = azurerm_resources_service.resource_groups.select { |rg| rg.name == rg_name }.first
  resource_group.destroy if resource_group
end

def zone_destroy
  zone = azurerm_dns_service.zones.select { |z| z.name == zone_name }.first
  zone.destroy if zone
end

at_exit do
  unless Fog.mocking?
    zone_destroy
    rg_destroy
  end
end