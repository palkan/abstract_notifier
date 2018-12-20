# frozen_string_literal: true

module AbstractNotifier
  module JobAdapters
    class << self
      def lookup(adapter, options = nil)
        return adapter unless adapter.is_a?(Symbol)

        adapter_class_name = adapter.to_s.split("_").map(&:capitalize).join
        JobAdapters.const_get(adapter_class_name).new(options || {})
      rescue NameError => e
        raise e.class, "Job adapter :#{adapter} haven't been found", e.backtrace
      end
    end
  end
end
