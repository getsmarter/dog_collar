module DogCollar
  module Contrib
    module Sidekiq
      module Configuration
        class Settings < Datadog::Contrib::Sidekiq::Configuration::Settings
          option :tag_args do |o|
            o.default { env_to_bool(Ext::ENV_TAG_JOB_ARGS, true) }
            o.lazy
          end

          option :service_name do |o|
            o.default { "#{Datadog.configuration.service}-sidekiq" }
            o.lazy
          end

          option :client_service_name do |o|
            o.default { "#{Datadog.configuration.service}-sidekiq-client" }
            o.lazy
          end
        end
      end
    end
  end
end
