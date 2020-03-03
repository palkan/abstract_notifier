# frozen_string_literal: true

module ActiveDelivery
  module Lines
    # AbstractNotifier line for Active Delivery.
    #
    # You must provide custom `resolver` to infer notifier class
    # (if String#safe_constantize is defined, we convert "*Delivery" -> "*Notifier").
    #
    # Resolver is a callable object.
    class Notifier < ActiveDelivery::Lines::Base
      DEFAULT_RESOLVER = ->(name) { name.gsub(/Delivery$/, "Notifier").safe_constantize }

      def initialize(**opts)
        super
        @resolver = opts[:resolver]
      end

      def resolve_class(name)
        resolver&.call(name)
      end

      def notify?(method_name)
        handler_class.action_methods.include?(method_name.to_s)
      end

      def notify_now(handler, mid, *args)
        handler.public_send(mid, *args).notify_now
      end

      def notify_later(handler, mid, *args)
        handler.public_send(mid, *args).notify_later
      end

      private

      attr_reader :resolver
    end

    # Only automatically register line when we can resolve the class
    # easily.
    if "".respond_to?(:safe_constantize)
      ActiveDelivery::Base.register_line :notifier, Notifier, resolver: Notifier::DEFAULT_RESOLVER
    end
  end
end
