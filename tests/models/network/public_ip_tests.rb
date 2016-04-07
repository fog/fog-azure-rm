require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | public_ip model', %w(azurerm network)) do
  pubip = fog_public_ip

  tests('The record_set model should') do
    tests('have attributes') do
      model_attribute_hash = pubip.attributes
      attributes = [
          :name,
          :resource_group,
          :location,
          :type
      ]
      tests('The public_ip model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { pubip.respond_to? attribute }
        end
      end
      tests('The attributes hash should have key') do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
  end
end
