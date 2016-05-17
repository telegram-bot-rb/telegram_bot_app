# Example telegram bot app

This app uses [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot) gem.

Explore separate commits to check evolution of code.

## Commands

- `/start` - Greeting.
- '/help'
- `/memo %text%` - Saves text to session.
- `/remind_me` - Replies with text from session.
- `/keyboard` - Simple keyboard.
- `/inline_keyboard` - Inline keyboard example.

## Setup

- Clone repo.
- run `./bin/setup`.
- Update `config/secrets.yml` with your bot's token.

## Run

### Development

```
bin/rake telegram:bot:poller
```

### Production

You may want to use different token, because after you setup webhook
you'll need to unset it to run development poller again.

```
bin/rake telegram:bot:set_webhook RAILS_ENV=production
```

And deploy it in any way.

### Testing

```
bin/rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/telegram-bot-rb/telegram_bot_app.
