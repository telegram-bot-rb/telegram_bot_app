class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def start(*)
    reply_with :message, text: 'Hi there!'
  end

  def message(message)
    reply_with :message, text: "You wrote: #{message['text']}"
  end

  def action_missing(action)
    reply_with :message, text: "Can not perform #{action}" if command?
  end
end
