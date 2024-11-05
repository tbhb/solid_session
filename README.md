# Solid Session

Database-backed [session store](https://guides.rubyonrails.org/security.html#session-storage) for [Rails](https://rubyonrails.org). It is a modernization of the [activerecord-session_store](https://github.com/rails/activerecord-session_store) gem that was previously extracted from Rails.

## Features and roadmap

- [x] Compact, encrypted serialization with [MessagePack](https://msgpack.org/) (inspired by [Solid Cache](https://github.com/rails/solid_cache))
- [x] Built-in [ActiveJob](https://edgeguides.rubyonrails.org/active_job_basics.html) job for trimming inactive sessions
- [x] Tested with MySQL, PostgreSQL, and SQLite
- [x] Instrumentation with [ActiveSupport::Notifications](https://guides.rubyonrails.org/active_support_instrumentation.html)
- [ ] Session metadata tracking (IP address, user agent, geocoding)
- [ ] Support for dedicated sessions database
- [ ] Installation generator
- [ ] Integration test helpers for Minitest and RSpec
- [ ] `mission_control-sessions` gem for monitoring and administration

## Prerequisites

- Ruby >= 3.2.0
- Rails >= 8.0.0.rc2

## Installation

Add Solid Session to your application by following these steps:

1. `bundle add solid_session`
2. `bin/rails solid_session:install:migrations`
3. `bin/rails db:migrate`

[ActiveRecord encryption](https://guides.rubyonrails.org/active_record_encryption.html) must be enabled in order to use Solid Session. Follow the instructions in [the guide](https://guides.rubyonrails.org/active_record_encryption.html#setup) to configure.

Then, set your session store in `config/initializers/session_store.rb`:

```ruby
Rails.application.config.session_store :solid_session_store, key: '_my_app_session`
```

When [Solid Queue](https://github.com/rails/solid_queue) is used as your ActiveJob queue adapter, add `SolidSession::TrimSessionsJob` to `config/recurring.yml`:

```ruby
production:
  trim_sessions:
    class: "SolidSession::TrimSessionsJob"
    schedule: every day
```

## Instrumentation

Solid Session instruments session store operations with `ActiveSupport::Notifications`:

### `session_read.solid_session`

| Key    | Value                 |
| ------ | --------------------- |
| `:sid` | The hashed session ID |

```ruby
{
  sid: '2::350cabf53a661de4fcf3d0ba6c6c65fd560b41e9697cf000168a9f420fb5366a'
}
```

### `session_write.solid_session`

| Key    | Value                 |
| ------ | --------------------- |
| `:sid` | The hashed session ID |

```ruby
{
  sid: '2::350cabf53a661de4fcf3d0ba6c6c65fd560b41e9697cf000168a9f420fb5366a'
}
```

### `session_delete.solid_session`

| Key    | Value                 |
| ------ | --------------------- |
| `:sid` | The hashed session ID |

```ruby
{
  sid: '2::350cabf53a661de4fcf3d0ba6c6c65fd560b41e9697cf000168a9f420fb5366a'
}
```

## Acknowledgements

This gem builds upon the excellent work of many contributors in the Ruby on Rails ecosystem. Special thanks to:

- The Rails core team and contributors, whose test suites and session store implementations in Rails itself core provided a robust foundation.
- The maintainers and contributors of the original `activerecord-session_store` gem, whose longstanding work influenced this implementation.
- The Solid Cache and Solid Queue maintainers and contributors, particularly for their modern database interaction patterns.

Portions of the gem boilerplate, implementation, and test suite and gem infrastructure were adapted from these projects, each of which are also distributed under the MIT License.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
