# Example telegram bot app

This app uses [telegram-bot](https://github.com/telegram-bot-rb/telegram-bot) gem.

Explore separate commits to check evolution of code.

## Commands

- `/start` - Greeting.
- `/help`
- `/memo %text%` - Saves text to session.
- `/remind_me` - Replies with text from session.
- `/keyboard` - Simple keyboard.
- `/inline_keyboard` - Inline keyboard example.
- Inline queries. Enable it in [@BotFather](https://telegram.me/BotFather),
  and your're ready to try 'em.
- `/last_chosen_inline_result` - Your last chosen inline result
  (Enable feedback with sending `/setinlinefeedback`
  to [@BotFather](https://telegram.me/BotFather)).

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

One way is just to run poller. You don't need anything else, just check
your production secrets & configs. But there is better way: use webhooks.

__You may want to use different token: after you setup the webhook,
you need to unset it to run development poller again.__

First you need to setup the webhook. There is rake task for it,
but you're free to set it manually with API call.
To use rake task you need to set host in `config.routes.default_url_options`
for production environment. There is already such line in the repo in `production.rb`.
Uncomment it, change the values, and you're ready for:

```
bin/rake telegram:bot:set_webhook RAILS_ENV=production
```

Now deploy your app in any way you like. You don't need run anything special for bot,
but `rails server` as usual. Your rails app will receive webhooks and bypass them
to bot's controller.

### Testing

```
bin/rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/telegram-bot-rb/telegram_bot_app.
