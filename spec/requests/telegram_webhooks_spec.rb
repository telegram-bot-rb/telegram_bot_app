RSpec.describe TelegramWebhooksController, telegram_bot: :rails do
  describe '#start!' do
    subject { -> { dispatch_command :start } }
    it { should respond_with_message 'Hi there!' }
  end

  describe '#help!' do
    subject { -> { dispatch_command :help } }
    it { should respond_with_message(/Available cmds/) }
  end
end
