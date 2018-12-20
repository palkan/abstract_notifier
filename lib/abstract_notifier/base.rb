# frozen_string_literal: true

module AbstractNotifier
  # Notificaiton payload wrapper which contains
  # information about the current notifier class
  # and knows how to trigger the delivery
  class Notification
    attr_reader :payload, :owner

    def initialize(owner, payload)
      @owner = owner
      @payload = payload
    end

    def notify_later
      return if AbstractNotifier.noop?
      owner.async_adapter.enqueue owner, payload
    end

    def notify_now
      return if AbstractNotifier.noop?
      owner.driver.call(payload)
    end
  end

  # Base class for notifiers
  class Base
    class << self
      alias with new

      attr_writer :driver

      def driver
        return @driver if instance_variable_defined?(:@driver)

        @driver =
          if superclass.respond_to?(:driver)
            superclass.driver
          else
            raise "Driver not found for #{name}. " \
                  "Please, specify driver via `self.driver = MyDriver`"
          end
      end

      def async_adapter=(args)
        adapter, options = Array(args)
        @async_adapter = AsyncAdapters.lookup(adapter, options)
      end

      def async_adapter
        return @async_adapter if instance_variable_defined?(:@async_adapter)

        @async_adapter =
          if superclass.respond_to?(:async_adapter)
            superclass.async_adapter
          else
            AbstractNotifier.async_adapter
          end
      end

      def method_missing(method_name, *args)
        if action_methods.include?(method_name.to_s)
          new.public_send(method_name, *args)
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        action_methods.include?(method_name.to_s) || super
      end

      # See https://github.com/rails/rails/blob/b13a5cb83ea00d6a3d71320fd276ca21049c2544/actionpack/lib/abstract_controller/base.rb#L74
      def action_methods
        @action_methods ||= begin
          # All public instance methods of this class, including ancestors
          methods = (public_instance_methods(true) -
            # Except for public instance methods of Base and its ancestors
            Base.public_instance_methods(true) +
            # Be sure to include shadowed public instance methods of this class
            public_instance_methods(false))

          methods.map!(&:to_s)

          methods.to_set
        end
      end
    end

    attr_reader :params

    def initialize(**params)
      @params = params.freeze
    end

    def notification(**payload)
      raise ArgumentError, "Notification body must be present" if
        payload[:body].nil? || payload[:body].empty?
      Notification.new(self.class, payload)
    end
  end
end
