require 'ddtrace'

class FakeWriter < Datadog::Writer
  def initialize
    super
    @spans = []
  end

  def write(trace)
    @spans << trace
  end

  def spans
    @spans.flatten
  end

  def find_span_by_name(name)
    span = spans.find { |span| span.name == name }
    raise StandardError, "No span with name '#{name}' found" if span.nil?
    span
  end
end
