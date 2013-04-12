# Relay

Relay is a text message relay initially developed for emergency communication among the queer/trans/punk/whatever-folk of southwest Montréal.

## Commands

* `subscribe (optional name)`
* `about`
* `unsubscribe`
* `nick (optional name)`

Admin-only commands:

* `freeze`
* `thaw`

Messages beginning with `@` will be sent to the subscriber with that name.

Other messages are forwarded to all subscribers if you are subscribed.

## Infrastructure

The relay is driven by Twilio and deployed on Heroku. More to come on this.

## Version history

* 0.2.1: Added `freeze`/`thaw`
* 0.2: Changed `nick` to `name`, ensure uniqueness
* 0.1: Initial release
