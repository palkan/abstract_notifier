# frozen_string_literal: true

require "spec_helper"

describe ActiveDelivery::Lines::Notifier do
  before do
    module ::DeliveryTesting
      class TestNotifier < AbstractNotifier::Base
        def do_something(msg)
          notification(
            body: msg,
            to: params[:user]
          )
        end

        private

        def do_nothing
        end
      end

      class TestDelivery < ActiveDelivery::Base
        if ENV["NO_RAILS"]
          register_line :notifier, ActiveDelivery::Lines::Notifier,
                        resolver: ->(name) { ::DeliveryTesting.const_get(name.gsub(/Delivery$/, "Notifier")) }
        end
      end
    end
  end

  after do
    Object.send(:remove_const, :DeliveryTesting)
  end

  let(:delivery_class) { ::DeliveryTesting::TestDelivery }
  let(:notifier_class) { ::DeliveryTesting::TestNotifier }

  describe ".notifier_class" do
    it "infers notifier from delivery name" do
      expect(delivery_class.notifier_class).to be_eql(notifier_class)
    end
  end

  describe ".notify" do
    describe ".notify" do
      it "enqueues notification" do
        expect { delivery_class.with(user: "Shnur").notify(:do_something, "Magic people voodoo people!") }
          .to have_enqueued_notification(body: "Magic people voodoo people!", to: "Shnur")
      end

      it "do nothing when notifier doesn't have provided public method" do
        expect { delivery_class.notify(:do_nothing) }
          .not_to have_enqueued_notification
      end
    end

    describe ".notify!" do
      it "sends notification" do
        expect { delivery_class.with(user: "Shnur").notify!(:do_something, "Voyage-voyage!") }
          .to have_sent_notification(body: "Voyage-voyage!", to: "Shnur")
      end
    end
  end
end
