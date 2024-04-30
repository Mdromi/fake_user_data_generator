require 'faker'

module Constants
  REGION_LANGUAGE_MAP = {
    'USA' => Faker::Config.locale = :en,
    'Australia' => Faker::Config.locale = :en_AU,
    'Russia' => Faker::Config.locale = :ru,
    'Polish' => Faker::Config.locale = :pl,
  }.freeze

  DEFAULT_TIMEOUT = 1000
end
