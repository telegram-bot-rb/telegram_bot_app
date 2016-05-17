class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def start(*)
    reply_with :message, text: 'Hi there!'
  end

  def help(*)
    reply_with :message, text: <<-TXT.strip_heredoc
      Available cmds:
      /memo %text% - Saves text to session.
      /remind_me - Replies with text from session.
      /keyboard - Simple keyboard.
      /inline_keyboard - Inline keyboard example.
      Bot supports inline queries. Enable it in @BotFather.
    TXT
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

  def inline_keyboard
    reply_with :message, text: 'Check my inline keyboard:', reply_markup: {
      inline_keyboard: [
        [
          {text: 'Answer with alert', callback_data: 'alert'},
          {text: 'Without alert', callback_data: 'no_alert'},
        ],
        [{text: 'Open gem repo', url: 'https://github.com/telegram-bot-rb/telegram-bot'}],
      ],
    }
  end

  def callback_query(data)
    if data == 'alert'
      answer_callback_query 'This is ALERT-T-T!!!', show_alert: true
    else
      answer_callback_query 'Simple answer'
    end
  end

  def message(message)
    reply_with :message, text: "You wrote: #{message['text']}"
  end

  def inline_query(query, offset)
    query = query.first(10) # it's just an example, don't use large queries.
    results = 5.times.map do |i|
      {
        type: :article,
        title: "#{query}-#{i}",
        id: "#{query}-#{i}",
        description: "description #{i}",
        input_message_content: {
          message_text: "content #{i}",
        },
      }
    end
    answer_inline_query results
  end

  # There are no such requests from telegram :(
  # If you know, how can this be performed, open an issue pls.
  def chosen_inline_result(result_id, query)
    reply_with :message, "Query: #{query}\nYou've chosen: #{result_id}"
  end

  def action_missing(action, *_args)
    reply_with :message, text: "Can not perform #{action}" if command?
  end
end
