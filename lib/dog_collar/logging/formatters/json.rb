require 'json'

module DogCollar
  module Logging
    module Formatters
      class JSON
        attr_accessor :datetime_format

        def call(severity, time, progname, msg, meta)
          data = meta.merge(format_message(msg))
          data[:status] = format_severity(severity)
          data[:@timestamp] = format_time(time)
          data.to_json + "\n"
        end

        private

        # These labels should map to the correct status according to the default
        # log status remapping rules:
        #
        #   https://docs.datadoghq.com/logs/processing/processors/?tab=ui#log-status-remapper
        #
        SEV_LABEL = %w(debug info warn error fatal any).freeze

        def format_severity(severity)
          SEV_LABEL[severity] || 'any'
        end

        def format_time(time)
          datetime_format.nil? ? time.iso8601(3) : time.strftime(datetime_format)
        end

        def format_message(msg)
          case msg
          when ::String
            { message: msg }
          when ::Exception
            { error: format_error(msg) }
          when ::NilClass
            {}
          else
            { message: msg.inspect }
          end
        end

        def format_error(exception)
          { kind: exception.class.to_s, message: exception.message, backtrace: exception.backtrace.join("\n") }
        end
      end
    end
  end
end
