# frozen_string_literal: true

module Minitest
  module Assertions
    def assert_delivery(args)
      yield
      assert_equal args, AbstractNotifier::Testing::Driver.deliveries.last
    end

    def assert_async_delivery(args)
      yield
      assert_equal args, AbstractNotifier::Testing::Driver.enqueued_deliveries.last
    end
  end
end
