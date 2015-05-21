shared_examples_for 'publishing' do
  it 'calls publish' do
    expect(Danthes).to receive(:publish_to).with(publish_url, anything)
    make_request
  end
end 