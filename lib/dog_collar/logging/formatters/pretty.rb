require 'amazing_print'

module DogCollar
  module Logging
    module Formatters
      class Pretty
        attr_accessor :datetime_format, :trace_indent

        def initialize
          @datetime_format = '%Y %b %-d %H:%M:%S'
          @trace_indent = 4
        end

        def call(severity, time, progname, msg, meta)
          datetime = format_datetime(time)
          severity = format_severity(severity)
          message = format_message(msg)
          prefix = "[#{datetime}] #{severity}: #{message}"

          if meta.empty?
            prefix
          else
            prefix + "\n" + meta.ai
          end
        end

        private
        def format_message(message)
          case message
          when ::String
            message
          when ::Exception
            format_exception(message)
          when NilClass
          else
            message.ai
          end
        end

        def format_exception(exc)
          backtrace = exc.backtrace.map { |line| " " * @trace_indent + line }.join("\n")
          "#{exc.class} #{exc.message}\n#{backtrace}"
        end

        def format_datetime(time)
          time.strftime(datetime_format)
        end

        SEV_LABEL = %w(DEBUG INFO WARN ERROR FATAL ANY).freeze
        SEV_COLOR = %w(0;37 0;36 0;33 0;31 0;35 0;32).freeze

        def format_severity(severity)
          label = SEV_LABEL[severity] || 'ANY'
          color = SEV_COLOR[severity] || '0;32'
          "\e[#{color}m#{label}\e[0m"
        end
      end
    end
  end
end
