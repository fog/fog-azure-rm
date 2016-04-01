require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::DNS[:azurerm] | record_set model', %w(azurerm dns)) do
  rset = fog_record_set

  tests('The record_set model should') do
    tests('have attributes') do
      model_attribute_hash = rset.attributes
      attributes = [
        :name,
        :resource_group,
        :zone_name,
        :records,
        :type,
        :ttl
      ]
      tests('The record_set model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { rset.respond_to? attribute }
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
