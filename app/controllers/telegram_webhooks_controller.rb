class TelegramWebhooksController < Telegram::Bot::UpdatesController
  use_session!

  def start(*)
    reply_with :message, text: 'Hi there!'
  end

  def memo(*args)
    if args.any?
      session[:memo] = args.join(' ')
      reply_with :message, text: 'Remembered!'
    else
      reply_with :message, text: 'Type what to remember right after command'
    end
  end

  def remind_me
    to_remind = session.delete(:memo)
    reply = to_remind || 'Nothing to remind'
    reply_with :message, text: reply
  end

  def message(message)
    reply_with :message, text: "You wrote: #{message['text']}"
  end

  def action_missing(action)
    reply_with :message, text: "Can not perform #{action}" if command?
  end
end
