shared_examples_for "a management updater" do
  let(:user) { stub }
  let(:opts) { { :title => 'test', :id => 1 } }
  let(:request) { stub(:post => opts) } 

  before do
    Legato::Management::Request.stubs(:new).returns(request)
  end

  it "#{subject_class_name} should call post for insert methods" do
    described_class.stubs(:new).returns('thing1', 'thing2')

    described_class.update_or_insert({ :id => 1 })
  end
end
