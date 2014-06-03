require 'spec_helper'

describe TxtsController, :type => :controller do
  it "delegates to Executor" do
    txt = double
    allow(Txt).to receive(:create).and_return(txt)

    executor = double
    expect(Executor).to receive(:new).with(txt, {application_url: incoming_txts_url}).and_return(executor)
    expect(executor).to receive(:execute)

    post :incoming, Body: ''
  end
end
