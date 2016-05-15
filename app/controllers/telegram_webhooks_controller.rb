class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def start(*)
    reply_with :message, text: 'Hi there!'
  end
end
