# Change log

## master

## 0.3.2 (2022-06-02)

- Added Minitest assertions. ([@komagata][])

## 0.3.1 (2020-04-09)

- Fix loading testing utils. ([@brovikov][])

Change the RSpec check to `defined?(RSpec::Core)` to prevent from
loading testing utils when only `RSpec` module is defined.

## 0.3.0 (2020-03-02)

- **Drop Ruby 2.4 support**. ([@palkan][])

## 0.2.0 (2018-01-11)

- Add class-level defaults. ([@palkan][])

- Add `#notification_name`. ([@palkan][])

## 0.1.0 (2018-12-21)

Initial version.

[@palkan]: https://github.com/palkan
[@brovikov]: https://github.com/brovikov
[@komagata]: https://github.com/komagata
