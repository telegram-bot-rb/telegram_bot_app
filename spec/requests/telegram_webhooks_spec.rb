RSpec.describe TelegramWebhooksController, telegram_bot: :rails do
  describe '#start!' do
    subject { -> { dispatch_command :start } }
    it { should respond_with_message 'Hi there!' }
  end

  describe '#help!' do
    subject { -> { dispatch_command :help } }
    it { should respond_with_message(/Available cmds/) }
  end

  describe 'memoizing with /memo' do
    let(:memo) { ->(text) { dispatch_command :memo, text } }
    let(:remind_me) { -> { dispatch_command :remind_me } }
    let(:text) { 'asd qwe' }

    it 'memoizes from the single message' do
      expect(&remind_me).to respond_with_message 'Nothing to remind'
      expect { memo[text] }.to respond_with_message 'Remembered!'
      expect(&remind_me).to respond_with_message text
      expect(&remind_me).to respond_with_message 'Nothing to remind'
    end

    it 'memoizes text from subsequest message' do
      expect { memo[''] }.to respond_with_message 'What should I remember?'
      expect { dispatch_message text }.to respond_with_message 'Remembered!'
      expect(&remind_me).to respond_with_message text
    end
  end

  describe '#keyboard!' do
    subject { -> { dispatch_command :keyboard } }
    it 'shows keyboard' do
      should respond_with_message 'Select something with keyboard:'
      expect(bot.requests[:sendMessage].last[:reply_markup]).to be_present
    end

    context 'when keyboard button selected' do
      subject { -> { dispatch_message 'Smth' } }
      before { dispatch_command :keyboard }
      it { should respond_with_message "You've selected: Smth" }
    end
  end

  describe '#message' do
    subject { -> { dispatch_message text } }
    let(:text) { 'some plain text' }
    it { should respond_with_message "You wrote: #{text}" }
  end

  context 'for unsupported command' do
    subject { -> { dispatch_command :makeMeGreatBot } }
    it { should respond_with_message 'Can not perform makeMeGreatBot' }
  end

  context 'for unsupported feature' do
    subject { -> { dispatch time_travel: {back_to: :the_future} } }
    it 'does nothing' do
      subject.call
      expect(response).to be_ok
    end
  end
end
