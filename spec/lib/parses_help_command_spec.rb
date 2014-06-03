require_relative '../../lib/parses_help_command'

module I18n; end

describe ParsesHelpCommand do
  let(:locale) { :locale }

  def parse(command)
    ParsesHelpCommand.new(command, locale).parse
  end

  it 'parses an existing command' do
    expect(I18n).to receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    expect(parse('command')).to eq(:command)
  end

  it 'parses a command with different names' do
    expect(I18n).to receive(:t).with('commands', locale: locale).and_return({:command => ['one', 'two']})
    expect(parse('two')).to eq(:command)
  end

  it 'ignores case' do
    expect(I18n).to receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    expect(parse('CommanD')).to eq(:command)
  end

  it 'ignores a leading slash' do
    expect(I18n).to receive(:t).with('commands', locale: locale).and_return({:command => 'command'})
    expect(parse('/command')).to eq(:command)
  end

  it 'returns nil for an unknown command' do
    expect(I18n).to receive(:t).with('commands', locale: locale).and_return({})
    expect(parse('command')).to be_nil
  end
end
