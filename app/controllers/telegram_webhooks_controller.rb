class TelegramWebhooksController < Telegram::Bot::UpdatesController
  def start!(*)
    respond_with :message, text: t('.content')
  end

  def help!(*)
    respond_with :message, text: t('.content')
  end
end
