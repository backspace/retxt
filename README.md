# retxt

retxt is a text message relay initially developed for emergency communication among the queer/trans/punk/whatever-folk of southwest Montréal.

## Commands

* `subscribe (optional name)`
* `about`
* `unsubscribe`
* `name (optional name)`

Admin-only commands:

* `/freeze`
* `/thaw`
* `/open`
* `/close`
* `/who`
* `/clear`
* `/delete`
* `/mute`
* `/unmute`
* `/create`
* `/clear`
* `/delete`
* `/admin`
* `/unadmin`

Messages beginning with `@` will be sent to the subscriber with that name.

Other messages are forwarded to all subscribers if you are subscribed.

## Infrastructure

The relay is driven by Twilio and deployed on Heroku. More to come on this.

## Version history

* 0.8: Updated to Rails 4.1, open sourced
* 0.6: Extracted commands from controller, added `/admin`/`/unadmin`
* 0.5: Add multi-relay capability and many admin commands
* 0.3: Store incoming messages, support direct messaging
* 0.2.1: Added `freeze`/`thaw`
* 0.2: Changed `nick` to `name`, ensure uniqueness
* 0.1: Initial release
