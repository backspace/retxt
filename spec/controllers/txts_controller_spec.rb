require 'spec_helper'

describe TxtsController do
  it "delegates to Executor" do
    txt = double
    Txt.stub(:create).and_return(txt)

    executor = double
    Executor.should_receive(:new).with(txt, {application_url: incoming_txts_url}).and_return(executor)
    executor.should_receive(:execute)

    post :incoming
  end
end
