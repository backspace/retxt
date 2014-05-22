require_relative '../../lib/parses_help_command'

module I18n; end

describe ParsesHelpCommand do
  let(:locale) { :locale }

  def parse(command)
    ParsesHelpCommand.new(command, locale).parse
  end

  it 'parses an existing command' do
    I18n.should_receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    parse('command').should eq(:command)
  end

  it 'parses a command with different names' do
    I18n.should_receive(:t).with('commands', locale: locale).and_return({:command => ['one', 'two']})
    parse('two').should eq(:command)
  end

  it 'ignores case' do
    I18n.should_receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    parse('CommanD').should eq(:command)
  end

  it 'ignores a leading slash' do
    I18n.should_receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    parse('/command').should eq(:command)
  end

  it 'returns nil for an unknown command' do
    I18n.should_receive(:t).with('commands', locale: locale).and_return({})
    parse('command').should be_nil
  end
end
