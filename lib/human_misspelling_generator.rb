# lib/human_misspelling_generator.rb
# require 'faker_helper'

module HumanMisspellingGenerator
  include FakerHelper  # Include FakerHelper module to access its methods

  class MisspellingStrategy
    def execute(record, random_field, random_char_index)
      raise NotImplementedError, 'Subclasses must override execute method'
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
    attr_reader :language_module, :strategies

    def initialize(language_module)
      @language_module = language_module
      @strategies = [
        AddCharacterStrategy.new,
        DeleteCharacterStrategy.new,
        SwapCharactersStrategy.new
      ]
    end

    def execute(record)
      error_variant = @language_module.number.int(2)
      fields = record.keys
      random_field = fields[@language_module.number.int(fields.length - 1)]
      random_char_index = @language_module.number.int(record[random_field].length > 0 ? record[random_field].length - 1 : record[random_field].length)
      @strategies[error_variant].execute(record, random_field, random_char_index)
    end

    def generate(error_count, record)
      integer_part = error_count.truncate
      fractional_part = error_count % 1

      range = (0...integer_part).to_a
      range.each { execute(record) }

      execute(record) if fractional_part * 100 > @language_module.number.int(100)

      record
    end
  end
end
