require 'faker'
class FakeDataGeneratorController < ApplicationController
  include FakerHelper
  include FakeDataGeneratorHelper

def index
  region = 'USA' # Set the desired region here

  error_count = 0

  generator = Generator.new(region)

  @generated_data = (1..20).map do |index|
    userData = generate_user_data(region, index)
    generatedData = generator.generate(error_count, { name: userData[:name], address: userData[:address], phone: userData[:phone] })
    {
      **generatedData,
      index: userData[:index],
      identifier: userData[:identifier]
    }
  end
end
end
