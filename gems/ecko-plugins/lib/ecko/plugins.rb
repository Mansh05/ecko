require "ecko/plugins/version"
require 'ecko/plugins/stripe'

module Ecko
  module Plugins
    class Error < StandardError; end

    class PluginPresentError < StandardError; end

    class Registry; end

    mattr_accessor :registry, default: {}

    class << self
      def register(name:, schema:, engine:)
        raise Ecko::Plugins::PluginPresentError if Ecko::Plugins.registry[name].present?

        registered_plugin = Ecko::Plugins::Registry.const_set(name.capitalize, Class.new(engine))
        Ecko::Plugins.registry[name] = { schema: schema, engine: engine, engine_stub: registered_plugin }
        execute_pipeline(registered_plugin, schema)
      end

      def execute_pipeline(registered_plugin, schema)
        define_singleton_method('stripe') do
          registered_plugin
        end

        registered_plugin.configure(schema)
      end
    end
  end
end

