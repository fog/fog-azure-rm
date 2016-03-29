require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::DNS[:azurerm] | zone model', %w(azurerm dns)) do
  zone = fog_zone

  tests('The zone model should') do
    tests('have the action') do
      test('reload') { zone.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = zone.attributes
      attributes = [
        :id,
        :name,
        :resource_group
      ]
      tests('The zone model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { zone.respond_to? attribute }
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
