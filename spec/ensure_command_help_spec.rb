describe 'command help existence' do
  it 'has command_help for every true command' do
    command_file_names = Dir.glob('app/commands/*.rb').map{|path| path.split('/').last.split('.').first}
    command_file_exceptions = %w{
      abstract_command
      direct_message
      modify_relay
      modify_subscription
      relay_command
    }

    commands_that_must_exist = command_file_names - command_file_exceptions

    commands_that_must_exist.each do |command_file_name|      
      fail "No command help was found for #{command_file_name}" unless I18n.exists? "txts.command_help.#{command_file_name}"
    end
  end
end
