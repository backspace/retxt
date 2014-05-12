Before do
  SendsTxts.stubs(:send_txt)

  original_stub = SendsTxts.method(:send_txt)

  # FIXME hack to store outgoing txts despite stubbing
  # https://stackoverflow.com/questions/803020/redefining-a-single-ruby-method-on-a-single-instance-with-a-lambda
  def define_singleton_method_by_proc(obj, name, block)
    metaclass = class << obj; self; end
    metaclass.send(:define_method, name, block)
  end

  define_singleton_method_by_proc(SendsTxts, :send_txt, Proc.new do |*args|
    options = args.first
    txt =  Txt.create(
      to: options[:to],
      from: options[:from],
      body: options[:body],
      originating_txt_id: options[:originating_txt_id]
    )

    original_stub.call(*args)
  end)
end

After do |scenario|
  if scenario.failed? && scenario.exception.message.include?("SendsTxts.send_txt")
    table = Terminal::Table.new(
      title: 'Calls to SendsTxts.send_txt',
      headings: ['from', 'to', 'body', 'originating_txt_id'],
      rows: Mocha::Mockery.instance.invocations.select{|invocation| invocation.method_name == :send_txt }.map(&:arguments).map(&:first).map{|arguments| [arguments[:from], arguments[:to], arguments[:body][0..30], arguments[:originating_txt_id]] }
    )

    STDOUT.puts table
  end

  SendsTxts.unstub(:send_txt)
  Mocha::Mockery.reset_instance
end
