require "faker"
include FakerHelper

module FakeDataGeneratorHelper
  class MisspellingStrategy
    def execute(record, random_field, random_char_index)
      raise NotImplementedError, "Subclasses must override execute method"
    end
  end

  class AddCharacterStrategy < MisspellingStrategy
    def execute(record, random_field, random_char_index)
      record[random_field] = add_character(record[random_field], random_char_index)
    end
  end

  class DeleteCharacterStrategy < MisspellingStrategy
    def execute(record, random_field, random_char_index)
      record[random_field] = delete_character(record[random_field], random_char_index)
    end
  end

  class SwapCharactersStrategy < MisspellingStrategy
    def execute(record, random_field, random_char_index)
      record[random_field] = swap_characters(record[random_field], random_char_index)
    end
  end

  class Generator
    attr_reader :strategies

    def initialize(region)
      Faker::Config.locale = Constants::REGION_LANGUAGE_MAP[region]
      @strategies = [
        AddCharacterStrategy.new,
        DeleteCharacterStrategy.new,
        SwapCharactersStrategy.new,
      ]
    end

    def execute(record, seed = 0)
      # Set a fixed seed for the random number generator
      srand(seed)  # Choose any seed value you want

      error_variant = Faker::Number.number(digits: 2).to_i
      fields = record.keys
      random_field = fields.sample

      # Add a null check to ensure record[random_field] is not nil
      if record[random_field].nil?
        return
      end

      random_char_index = Faker::Number.between(from: 0, to: record[random_field].length - 1)
      @strategies[error_variant % @strategies.length].execute(record, random_field, random_char_index)
    end

    def generate(error_count, record)
      integer_part = error_count.truncate 
      fractional_part = error_count % 1

      range = (0...integer_part).to_a
      range.each { execute(record) }

      execute(record) if fractional_part * 100 > Faker::Number.number(digits: 100).to_i

      record
    end
  end
end
