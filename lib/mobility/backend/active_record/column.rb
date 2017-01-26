module Mobility
  module Backend
    class ActiveRecord::Column
      include Backend
      include Mobility::Backend::Column

      autoload :QueryMethods, 'mobility/backend/active_record/column/query_methods'

      def self.configure!(options)
        options[:locale_accessors] = false
      end

      setup do |attributes, options|
        mod = Module.new do
          define_method :i18n do
            @mobility_scope ||= super().extending(QueryMethods.new(attributes, options))
          end
        end
        extend mod
      end
    end
  end
end
