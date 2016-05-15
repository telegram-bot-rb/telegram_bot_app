require 'telegram/bot/updates_controller/rspec_helpers'

RSpec.describe TelegramWebhooksController, type: :telegram_controller do
  include_context 'telegram/bot/updates_controller'
  let(:message_options) { {from: {id: 123}, chat: {id: 456}} }

  # TODO: no time to write matcher now.
  def should_reply_with(expected)
    should change { bot.requests[:sendMessage].size }.by(1)
    reply = bot.requests[:sendMessage].last
    expect(reply[:chat_id]).to eq message_options[:chat][:id]
    expect(reply[:text]).to eq expected
  end

  describe '#start' do
    subject { -> { dispatch_message "/start", message_options } }
    it { should_reply_with 'Hi there!' }
  end

  describe '#message' do
    subject { -> { dispatch_message text, message_options } }
    let(:text ) { 'some plain text' }
    it { should_reply_with  "You wrote: #{text}" }
  end

  describe 'for unsupported command' do
    subject { -> { dispatch_message '/makeMeGreatBot', message_options } }
    it { should_reply_with 'Can not perform makemegreatbot' }
  end
end
