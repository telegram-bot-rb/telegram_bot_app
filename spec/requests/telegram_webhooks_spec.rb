RSpec.describe TelegramWebhooksController, telegram_bot: :rails do
  describe '#start!' do
    subject { -> { dispatch_command :start } }
    it { should respond_with_message 'Hi there!' }
  end

  describe '#help!' do
    subject { -> { dispatch_command :help } }
    it { should respond_with_message(/Available cmds/) }
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
