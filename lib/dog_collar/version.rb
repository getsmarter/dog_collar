# frozen_string_literal: true

module DogCollar
  module VERSION
    MAJOR = 0
    MINOR = 5
    PATCH = 2
    PRE = nil

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join('.')

    MINIMUM_RUBY_VERSION = '2.3.0'
  end
end
