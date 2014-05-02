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

## Deployment

The application is currently dependent on Twilio, though the service is sufficiently decoupled that changing that is possible if there’s interest. To deploy to Heroku, you need your Twilio account SID and auth token.

    heroku create your-relay-name
    heroku addons:add mongolab
    heroku addons:add newrelic:stark

    # Use your Twilio authentication data for these
    heroku config:set TWILIO_ACCOUNT_SID=YOUR_ACCOUNT_SID
    heroku config:set TWILIO_AUTH_TOKEN=YOUR_AUTH_TOKEN

    heroku config:set SECRET_KEY=`rake secret`
    heroku config:set DEVISE_KEY=`rake secret`


    git push heroku master

Once the push is complete, visit https://your-relay-name.herokuapp.com/ to complete setup. You will be asked to create an account that can administer the relay (very rudimentary for now) and give a phone number, from a which a relay with the same area code will be created.

You will receive a message from the new relay. Read up at https://your-relay-name.herokuapp.com/ to learn the supported commands.

## Version history

* 0.8.1: Ruby 2.1, Heroku/Twilio deployment information, Travis
* 0.8: Updated to Rails 4.1, open sourced
* 0.6: Extracted commands from controller, added `/admin`/`/unadmin`
* 0.5: Add multi-relay capability and many admin commands
* 0.3: Store incoming messages, support direct messaging
* 0.2.1: Added `freeze`/`thaw`
* 0.2: Changed `nick` to `name`, ensure uniqueness
* 0.1: Initial release
