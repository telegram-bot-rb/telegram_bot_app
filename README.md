# Example telegram bot app

This app uses [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot) gem.

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

## Commands

- `/start` - Greeting.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/telegram-bot-rb/telegram_bot_app.
