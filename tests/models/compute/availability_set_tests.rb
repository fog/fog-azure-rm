require File.expand_path('../../../helper', __FILE__)
# rubocop:disable LineLength
Shindo.tests('Fog::Compute[:azurerm] | availability_set model', %w(azurerm compute)) do
  availability_set = fog_availability_set

  tests('The availability set model should') do
    tests('have the action') do
      test('reload') { availability_set.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = availability_set.attributes
      attributes = [
        :name,
        :location,
        :resource_group
      ]
      tests('The availability set model should respond to') do
        attributes.each do |attribute|
          test(attribute) { availability_set.respond_to? attribute }
        end
      end
      tests('The attributes hash should have key') do
        attributes.each do |attribute|
          test(attribute) { model_attribute_hash.key? attribute }
        end
      end
    end
  end
end
