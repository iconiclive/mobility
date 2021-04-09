# frozen-string-literal: true

module Mobility
  module Plugins
=begin

Plugin to use an original column for a given locale, and otherwise use the backend.

=end
    module ActiveRecord
      module OriginalColumn
        extend Plugin

        requires :original_column, include: false

        included_hook do |_, backend_class|
          if options[:original_column]
            backend_class.include BackendInstanceMethods
            backend_class.extend BackendClassMethods
          end
        end

        module BackendInstanceMethods
          def read(locale, **)
            if locale == I18n.default_locale
              model.read_attribute(attribute)
            else
              super
            end
          end

          def write(locale, value, **)
            if locale == I18n.default_locale
              model.write_attribute(attribute, value)
            else
              super
            end
          end
        end

        module BackendClassMethods
          def build_node(attr, locale)
            if locale == I18n.default_locale
              # is the MobilityExpressions plugin necessary here?
              model_class.arel_table[attr].extend(Plugins::Arel::MobilityExpressions)
            else
              super
            end
          end

          # def apply_scope
          #   super
          # end
        end
      end
    end

    register_plugin(:active_record_original_column, ActiveRecord::OriginalColumn)
  end
end
