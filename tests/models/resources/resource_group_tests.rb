require File.expand_path('../../../helper', __FILE__)

Shindo.tests("Fog::Resources[:azurerm] | resource_group model", ["azurerm", "resources"]) do

  resource_group = fog_resource_group

  tests("The resource group model should") do

    tests("have the action") do
      test("reload") { resource_group.respond_to? "reload" }
    end
    tests("have attributes") do
      model_attribute_hash = resource_group.attributes
      attributes = [
          :id,
          :name,
          :location
      ]
      tests("The resource group model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { resource_group.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
  end
end