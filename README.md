[![Gem Version](https://badge.fury.io/rb/abstract_notifier.svg)](https://badge.fury.io/rb/abstract_notifier)
[![Build Status](https://travis-ci.org/palkan/abstract_notifier.svg?branch=master)](https://travis-ci.org/palkan/abstract_notifier)

# Abstract Notifier

Abstract Notifier is a tool which allows you to describe/model any text-based notifications (such as Push Notifications) the same way Action Mailer does for email notifications.

Abstract Notifier (as the name states) doesn't provide any specific implementation for sending notifications. Instead, it offers tools to organize your notification-specific code and make it easily testable.

<a href="https://evilmartians.com/?utm_source=action_policy">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

Requirements:
- Ruby ~> 2.3

**NOTE**: although most of the examples in this readme are Rails-specific, this gem could be used without Rails/ActiveSupport.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'abstract_notifier'
```

And then execute:

```sh
$ bundle
```

## Usage

Notifier class is very similar to Action Mailer mailer class with `notification` method instead of a `mail` method:

```ruby
class EventsNotifier < ApplicationNotifier
  def canceled(profile, event)
    notification(
      # the only required option is `body`
      body: "Event #{event.title} has been canceled",
      # all other options are passed to delivery driver
      identity: profile.notification_service_id
    )
  end
end

# send notification later
EventsNotifier.canceled(profile, event).notify_later

# or immediately
EventsNotifier.canceled(profile, event).notify_now
```

To perform actual deliveries you **must** configure a _delivery driver_:

```ruby
class ApplicationNotifier < AbstractNotifier::Base
  self.driver = MyFancySender.new
end
```

A driver could be any callable Ruby object (i.e., anything that responds to `#call`).

That's a developer responsibility to implement the driver (we do not provide any drivers out-of-the-box; at least yet).

You can set different drivers for different notifiers.

### Parameterized notifiers

Abstract Notifier support parameterization the same way as [Action Mailer]((https://api.rubyonrails.org/classes/ActionMailer/Parameterized.html)):

```ruby
class EventsNotifier < ApplicationNotifier
  def canceled(event)
    notification(
      body: "Event #{event.title} has been canceled",
      identity: params[:profile].notification_service_id
    )
  end
end

EventsNotifier.with(profile: profile).canceled(event).notify_later
```

### Background jobs / async notifications

To use `notify_later` you **must** configure `async_adapter`.

We provide Active Job adapter out-of-the-box and use it if Active Job is present.

The custom async adapter must implement `enqueue` method:

```ruby
class MyAsyncAdapter
  # adapters may accept options
  def initialize(options = {})
  end

  # `enqueue` method accepts notifier class and notification
  # payload.
  # We need to know notifier class to use its driver.
  def enqueue(notifier_class, payload)
    # your implementation here
  end
end

# Configure globally
AbstractNotifier.async_adapter = MyAsyncAdapter.new

# or per-notifier
class EventsNotifier < AbstractNotifier::Base
  self.async_adapter = MyAsyncAdapter.new
end
```

### Delivery modes

For test/development purposes there are two special _global_ delivery modes:

```ruby
# Track all sent notifications without peforming real actions.
# Required for using RSpec matchers.
#
# config/environments/test.rb
AbstractNotifier.delivery_mode = :test


# If you don't want to trigger notifications in development,
# you can make Abstract Notifier no-op.
#
# config/environments/development.rb
ActionNotifier.delivery_mode = :noop

# Default delivery mode is "normal"
ActionNotifier.delivery_mode = :normal
```

**NOTE:** we set `delivery_mode = :test` if `RAILS_ENV` or `RACK_ENV` env variable is equal to "test".
Otherwise add `require "abstract_notifier/testing"` to your `spec_helper.rb` / `rails_helper.rb` manually.

**NOTE:** delivery mode affects all drivers.

### Testing

Abstract Notifier provides two convinient RSpec matchers:

```ruby
# for testing sync notifications (sent with `notify_now`)
expect { EventsNotifier.with(profile: profile).canceled(event).notify_now }.
  to have_sent_notification(identify: '123', body: 'Alarma!')

# for testing async notifications (sent with `notify_later`)
expect { EventsNotifier.with(profile: profile).canceled(event).notify_later}.
  to have_enqueued_notification(identify: '123', body: 'Alarma!')
```

## Related projects

### [`active_delivery`](https://github.com/palkan/active_delivery)

Active Delivery is the next-level abstraction which allows combining multiple notification channels in one place.

Abstract Notifier provides a _notifier_ line for Active Delivery:

```ruby
class ApplicationDelivery < ActiveDelivery::Base
  # Add notifier line to you delivery
  register_line :notifier, ActiveDelivery::Lines::Notifier,
                # you may provide a resolver, which infers notifier class
                # from delivery name (resolver is a callable).
                resolver: ->(name) { resolve_somehow(name) }
end
```

**NOTE:** we automatically add `:notifier` line with `"*Delivery" -> *Notifier` resolution mechanism if `#safe_constantize` method is defined for String, i.e., you don't have to configure the default notifier line when running Rails.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/palkan/abstract_notifier.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
