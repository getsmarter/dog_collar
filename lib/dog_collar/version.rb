# frozen_string_literal: true

module DogCollar
  module VERSION
    MAJOR = 0
    MINOR = 3
    PATCH = 0
    PRE = nil

    STRING = [MAJOR, MINOR, PATCH, PRE].compact.join('.')

    MINIMUM_RUBY_VERSION = '2.0.0'
  end
end
