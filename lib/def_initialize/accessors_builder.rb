# frozen_string_literal: true

module DefInitialize
  module AccessorsBuilder
    class << self
      def build(accessors, readers_mode:, writers_mode:)
        check_option!(readers_mode)
        check_option!(writers_mode)

        result = ''.dup

        if readers_mode
          result << "#{readers_mode}\n"
          result << "attr_reader #{accessors.join(', ')}\n"
        end

        if writers_mode
          result << "#{writers_mode}\n"
          result << "attr_writer #{accessors.join(', ')}\n"
        end

        result
      end

      private

      def check_option!(value)
        return unless value
        return if %w[private public protected].include?(value.to_s)

        raise ArgumentError,
              "Uknown value #{value}. Must be :private, :public, :protected or nil"
      end
    end
  end
end
