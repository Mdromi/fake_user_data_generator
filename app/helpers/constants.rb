require 'faker'

module Constants
  REGION_LANGUAGE_MAP = {
    'USA' => Faker::Config.locale = :en,
    'German' => Faker::Config.locale = :de,
    'Russia' => Faker::Config.locale = :ru,
    'Polish' => Faker::Config.locale = :pl,
  }.freeze

  DEFAULT_TIMEOUT = 1000
end
