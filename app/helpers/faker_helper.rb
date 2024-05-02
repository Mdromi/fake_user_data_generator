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
    combined_seed = "#{seed}#{page}"
    hashed_seed = Digest::SHA256.hexdigest(combined_seed)
    Faker::Config.random = Random.new(hashed_seed.to_i(16))
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
    return str if str.nil?
    return str if str.length - 1 < index
  
    # Count the number of spaces in the string
    space_count = str.count(' ')
    
    # Check if the maximum space limit (3) is reached and the character at the index is a space
    return str if space_count >= 3 && str[index] == ' '
    
    # Insert the character at the specified index
    str.insert(index, str[index])
  end
  

  def delete_character(str, index)
    return str if str.nil? || index.nil? || index < 0 || index >= str.length || str.length <= 10
  
    str.slice(0, index) + str.slice(index + 1..-1)
  end
  

  def swap_characters(str, index)
    return str if str.nil? || index.nil? || index < 0 || index >= str.length - 1
  
    temp = str[index]
    str[index] = str[index + 1]
    str[index + 1] = temp
    str
  end

end
