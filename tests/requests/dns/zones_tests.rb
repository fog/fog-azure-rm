require File.expand_path('../../../helper', __FILE__)

Shindo.tests("Fog::DNS[:azurerm] | zones request", ["azurerm", "dns"]) do

  tests("#zones") do
    zones = azurerm_dns_service.zones
    zones = [fog_zone] if zones.empty?

    test "returns a Array" do
      zones.is_a? Array
    end

    test("should return valid zone name") do
      zones.first.name.is_a? String
    end

    test("should return records") do
      zones.size >= 1
    end
  end

end