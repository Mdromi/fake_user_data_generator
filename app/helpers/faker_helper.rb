# app/helpers/faker_helper.rb

require 'faker'

module FakerHelper
  def generate_random_identifier
    Faker::Internet.uuid
  end

  def generate_random_name
    Faker::Name.name
  end

  def generate_random_address
    Faker::Address.street_address
  end

  def generate_random_phone
    Faker::PhoneNumber.phone_number
  end

  def generate_random_seed
    Faker::Number.number(digits: 10).to_i
  end

  def set_faker_seed(seed, page = 0)
    Faker::Config.random = Random.new(seed)
  end

  def generate_user_data(region, index)
    Faker::Config.locale = Constants::REGION_LANGUAGE_MAP[region]
    identifier = generate_random_identifier
    name = generate_random_name
    address = generate_random_address
    phone = generate_random_phone
    { index: index, identifier: identifier, name: name, address: address, phone: phone }
  end

  def add_character(str, index)
    str.insert(index, str[index])
  end

  def delete_character(str, index)
    str.slice(0, index) + str.slice(index + 1..-1)
  end

  def swap_characters(str, index)
    if index == str.length - 1
      str.slice(0, index - 1) + str[index] + str[index - 1]
    else
      str[index], str[index + 1] = str[index + 1], str[index]
      str
    end
  end
end
