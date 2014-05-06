require_relative '../../lib/parses_commands'

require 'active_support/inflector'

describe ParsesCommands do
  before do
    stub_const('I18n', double)
    stub_const('RelayCommand', double('RelayCommand'))
  end

  subject { ParsesCommands.new(command, context, structure).parse }

  let(:context) { Object.new }
  let(:structure) { {} }

  describe 'with a simple command' do
    let(:command) { 'command' }

    it 'parses a given command' do
      stub_const('Command', double('Command'))
      I18n.should_receive(:t).with('commands').and_return({:command => 'command'})
      should eq(Command)
    end

    it 'parses a command whose class is different' do
      stub_const('Cmd', double('Cmd'))
      I18n.should_receive(:t).with('commands').and_return({:cmd => 'command'})
      should eq(Cmd)
    end

    it 'parses a command with multiple versions' do
      stub_const('Command', double('Command'))
      I18n.should_receive(:t).with('commands').and_return({:command => ['x', 'command']})
      should eq(Command)
    end

    it 'returns the RelayCommand when no command matches' do
      I18n.should_receive(:t).with('commands').and_return({})
      should eq(RelayCommand)
    end
  end

  describe 'with a slashed command' do
    let(:command) { '/command' }

    it 'returns the unknown command' do
      stub_const('Unknown', double('Unknown'))
      I18n.should_receive(:t).with('commands').and_return({})
      should eq(Unknown)
    end

    describe 'and a structure requiring a slash' do
      let(:structure) { {slash_requiring: [:command]} }

      it 'parses the command' do
        stub_const('Command', double('Command'))
        I18n.should_receive(:t).with('commands').and_return({:command => 'command'})
        should eq(Command)
      end
    end
  end

  describe 'with an addressed command' do
    let(:command) { '@something' }

    it 'returns the direct message command' do
      stub_const('DirectMessage', double('DirectMessage'))
      should eq(DirectMessage)
    end
  end

  describe 'with a partially matching command' do
    let(:command) { 'a' }

    it 'returns the RelayCommand' do
      I18n.should_receive(:t).with('commands').and_return({:abc => 'abc'})
      should eq(RelayCommand)
    end
  end
end
