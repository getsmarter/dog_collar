# frozen_string_literal: true

class TestError < StandardError
  def initialize(message)
    super
    set_backtrace(caller)
  end
end
