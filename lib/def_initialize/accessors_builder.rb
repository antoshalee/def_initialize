# frozen_string_literal: true

module DefInitialize
  module AccessorsBuilder
    class << self
      def build(accessors, readers_access_level:, writers_access_level:)
        part('attr_reader', readers_access_level, accessors) +
          part('attr_writer', writers_access_level, accessors)
      end

      private

      def part(attr_method, access_level, accessors)
        return '' unless access_level

        unless %w[private public protected].include?(access_level.to_s)
          raise ArgumentError,
                "Uknown access level #{access_level}. Must be :private, :public, :protected or nil"
        end

        "#{access_level}\n#{attr_method} #{accessors.join(', ')}\n"
      end
    end
  end
end
