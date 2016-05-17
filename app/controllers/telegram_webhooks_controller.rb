class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def start(*)
    reply_with :message, text: 'Hi there!'
  end

  def memo(*args)
    if args.any?
      session[:memo] = args.join(' ')
      reply_with :message, text: 'Remembered!'
    else
      reply_with :message, text: 'What should I remember?'
      save_context :memo
    end
  end

  def remind_me
    to_remind = session.delete(:memo)
    reply = to_remind || 'Nothing to remind'
    reply_with :message, text: reply
  end

  def keyboard(value = nil, *)
    if value
      reply_with :message, text: "You've selected: #{value}"
    else
      save_context :keyboard
      reply_with :message, text: 'Select something with keyboard:', reply_markup: {
        keyboard: [%w(Lorem Ipsum /cancel)],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end

  # v0.7
  # def message(message)
  #   reply_with :message, text: "You wrote: #{message['text']}"
  # end

  # v0.6
  context_handler do
    reply_with :message, text: "You wrote: #{payload['text']}"
  end

  def action_missing(action)
    reply_with :message, text: "Can not perform #{action}" if command?
  end
end
