# frozen_string_literal: true
require 'mobility/backends/active_record/pg_query_methods'
require "mobility/backends/active_record/query_methods"

module Mobility
  module Backends
    class ActiveRecord::Jsonb::QueryMethods < ActiveRecord::QueryMethods
      include ActiveRecord::PgQueryMethods

      def matches(key, locale)
        build_infix(:'->', arel_table[column_name(key)], build_quoted(locale))
      end

      def exists(key, locale)
        build_infix(:'?', arel_table[column_name(key)], build_quoted(locale))
      end

      def quote(value)
        build_quoted(value.to_json)
      end
    end
  end
end
