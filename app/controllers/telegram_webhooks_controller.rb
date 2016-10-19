class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  context_to_action!

  def start(*)
    respond_with :message, text: 'Hi there!'
  end

  def help(*)
    respond_with :message, text: <<-TXT.strip_heredoc
      Available cmds:
      /memo %text% - Saves text to session.
      /remind_me - Replies with text from session.
      /keyboard - Simple keyboard.
      /inline_keyboard - Inline keyboard example.
      Bot supports inline queries. Enable it in @BotFather.
      /last_chosen_inline_result - Your last chosen inline result \
      (Enable feedback with /setinlinefeedback).
    TXT
  end

  def memo(*args)
    if args.any?
      session[:memo] = args.join(' ')
      respond_with :message, text: 'Remembered!'
    else
      respond_with :message, text: 'What should I remember?'
      save_context :memo
    end
  end

  def remind_me
    to_remind = session.delete(:memo)
    reply = to_remind || 'Nothing to remind'
    respond_with :message, text: reply
  end

  def keyboard(value = nil, *)
    if value
      respond_with :message, text: "You've selected: #{value}"
    else
      save_context :keyboard
      respond_with :message, text: 'Select something with keyboard:', reply_markup: {
        keyboard: [%w(Lorem Ipsum /cancel)],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true,
      }
    end
  end

  def inline_keyboard
    respond_with :message, text: 'Check my inline keyboard:', reply_markup: {
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
    respond_with :message, text: "You wrote: #{message['text']}"
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

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: "You've chosen result ##{result_id}"
    else
      respond_with :message, text: 'Mention me to initiate inline query'
    end
  end

  def action_missing(action, *_args)
    if command?
      respond_with :message, text: "Can not perform #{action}"
    else
      respond_with :message, text: "#{action} feature is not implemented yet"
    end
  end
end
