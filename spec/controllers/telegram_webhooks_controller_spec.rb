require 'telegram/bot/updates_controller/rspec_helpers'

RSpec.describe TelegramWebhooksController, type: :telegram_controller do
  include_context 'telegram/bot/updates_controller'
  let(:chat_id) { 456 }
  let(:default_message_options) { {from: {id: 123}, chat: {id: chat_id}} }

  def reply
    bot.requests[:sendMessage].last
  end

  describe '#start' do
    subject { -> { dispatch_message "/start" } }
    it { should respond_with_message 'Hi there!' }
  end

  describe '#memo' do
    subject { -> { dispatch_message msg } }
    let(:msg) { "/memo #{text}" }
    let(:text) { 'asd qwe' }
    it { should change { session[:memo] }.from(nil).to(text) }
    it { should respond_with_message 'Remembered!' }

    context 'when no text given' do
      let(:text) {}
      it { should_not change { session[:memo] }.from(nil) }
      it { should respond_with_message 'What should I remember?' }
    end

    context 'when text is given in the second message' do
      before { dispatch_message '/memo' }
      let(:msg) { text }
      it { should change { session[:memo] }.from(nil).to(text) }
      it { should respond_with_message 'Remembered!' }
    end
  end

  describe '#remind_me' do
    subject { -> { dispatch_message '/remind_me' } }
    it { should respond_with_message 'Nothing to remind' }

    context 'when there is smth stored' do
      let(:stored) { 'stored message' }
      before { session[:memo] = stored }
      it { should respond_with_message stored }
    end
  end

  describe '#keyboard' do
    subject { -> { dispatch_message '/keyboard' } }
    it 'shows keyboard' do
      should respond_with_message 'Select something with keyboard:'
      expect(reply[:reply_markup]).to be_present
    end

    context 'when keyboard button selected' do
      subject { -> { dispatch_message 'Smth' } }
      before { dispatch_message '/keyboard' }
      it { should respond_with_message "You've selected: Smth" }
    end
  end

  describe '#message' do
    subject { -> { dispatch_message text } }
    let(:text ) { 'some plain text' }
    it { should respond_with_message "You wrote: #{text}" }
  end

  describe '#chosen_inline_result' do
    subject { -> { dispatch } }
    let(:payload_type) { :chosen_inline_result }
    let(:payload) { {from: {id: 123}, result_id: 456} }
    it { should change { session[:last_chosen_inline_result] }.to payload[:result_id] }
  end

  describe '#last_chosen_inline_result' do
    subject { -> { dispatch_message '/last_chosen_inline_result' } }
    it { should respond_with_message 'Mention me to initiate inline query' }

    context 'when user have already chosen smth' do
      let(:result_id) { 'result-123' }
      before { session[:last_chosen_inline_result] = result_id }
      it { should respond_with_message "You've chosen result ##{result_id}" }
    end
  end

  describe 'for unsupported command' do
    subject { -> { dispatch_message '/makeMeGreatBot' } }
    it { should respond_with_message 'Can not perform makemegreatbot' }
  end
end
