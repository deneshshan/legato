shared_examples_for "a management finder" do
  let(:user) { stub }
  let(:request) { stub(:get => items) }

  before do
    Legato::Management::Request.stubs(:new).returns(request)
  end

  context '# items returned' do
    let(:items) { ['item1', 'item2'] }

    it "returns an array of all #{subject_class_name} available to a user" do
      described_class.stubs(:new).returns('thing1', 'thing2')

      described_class.all(user).should == ['thing1', 'thing2']

      described_class.should have_received(:new).with('item1', user)
      described_class.should have_received(:new).with('item2', user)
    end
  end

  context '# no items returns' do
    let(:items) { [] }

    it "returns an empty array of #{subject_class_name} when there are no results" do
      MultiJson.stubs(:decode).returns({})
      described_class.all(user).should == []

      described_class.should have_received(:new).never
    end
  end
end
