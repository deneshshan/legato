require 'spec_helper'

describe Legato::Management::UnsampledReport do
  context '# The UnsampledReport class' do
    def self.subject_class_name
      "unsampled reports"
    end

    it_behaves_like "a management finder"
    it_behaves_like "a management updater"

    it 'creates a new unsampled report instance from a hash of attributes' do
      user = stub
      unsampled_report = Legato::Management::UnsampledReport.new(
        { "id" => 12345, 
          "title" => "Unsampled Report 1", 
          "accountId" => 333333, 
          "webPropertyId" => "WebProperty7", 
          "profileId" => "Profile 111", 
          "test" => "test one" }, 
      user) 

      unsampled_report.user.should == user
      unsampled_report.id.should == 12345
      unsampled_report.account_id.should == 333333
      unsampled_report.web_property_id.should == "WebProperty7"
      unsampled_report.profile_id.should == "Profile 111"

      unsampled_report.attributes["test"].should == "test one"

      ['id', 'webPropertyId', 'profileId', 'accountId']
        .each{ |key| unsampled_report.attributes.has_key?(key).should eq(false) }
    end

    it 'should set attributes to ~any if not obtainabled from user object' do
      user = stub(:accounts => [], :web_properties => [], :profiles => [])
      unsampled_report = Legato::Management::UnsampledReport.new({ }, user)

      unsampled_report.path.should == '/accounts/~all/webproperties/~all/profiles/~all/unsampledReports/'
    end

    context '# define some stuff' do
      let(:account) { stub(:user => 'user', :path => 'accounts/54321', 'id' => 54321) }
      let(:web_property) { stub(:user => 'user', :path => 'accounts/54321/webproperties/12345', 'id' => 12345) }
      let(:profile) { stub(:user => 'user', :path => 'accounts/54321/webproperties/12345/profiles/12345', 'id' => '12345') }

      it 'should set some attributes as those of user if not explicitly specified' do
        user =  stub(:accounts => [account], :web_properties => [web_property], :profiles => [profile])
        unsampled_report = Legato::Management::UnsampledReport.new({ }, user)

        unsampled_report.path.should == '/accounts/54321/webproperties/12345/profiles/12345/unsampledReports/'
      end

      describe '.for_account' do
        it 'returns an array of all unsampled reports available to a user under an account' do
          Legato::Management::UnsampledReport.stubs(:all)
          Legato::Management::UnsampledReport.for_account(account)
          Legato::Management::UnsampledReport.should have_received(:all)
            .with('user', 'accounts/54321/webproperties/~all/profiles/~all/unsampledReports')
        end
      end

      describe '.for_web_property' do
        it 'returns an array of all goals available to a user under an web property' do
          Legato::Management::UnsampledReport.stubs(:all)
          Legato::Management::UnsampledReport.for_web_property(web_property)
          Legato::Management::UnsampledReport.should have_received(:all)
            .with('user', 'accounts/54321/webproperties/12345/profiles/~all/unsampledReports')
        end
      end

      describe '.for_profile' do
        it 'returns an array of all goals available to a user under a profile' do
          Legato::Management::UnsampledReport.stubs(:all)
          Legato::Management::UnsampledReport.for_profile(profile)
          Legato::Management::UnsampledReport.should have_received(:all)
            .with('user', 'accounts/54321/webproperties/12345/profiles/12345/unsampledReports')
        end
      end
    end
  end

  context '# A UnsampledReport instance' do
    it 'builds the path for the goal from the id' do
      unsampled_report = Legato::Management::UnsampledReport.new({ 
        "id" => 54321, "accountId" => 33333, "webPropertyId" => 54321, "profileId" => 12345 
      }, stub)
      unsampled_report.path.should == '/accounts/33333/webproperties/54321/profiles/12345/unsampledReports/54321'
    end

    describe '.get' do
      let(:user) { stub }
      let(:unsampled_report) { 
        Legato::Management::UnsampledReport.new({
          'id' => 1,
          'accountId' => 999,
          'webPropertyId' => 1234,
          'profileId' => 7368
        }, user)
      }

      it 'should make an API call using correct user and path' do
        Legato::Management::UnsampledReport.stubs(:all)
        unsampled_report.get
        Legato::Management::UnsampledReport.should have_received(:all)
          .with(user, '/accounts/999/webproperties/1234/profiles/7368/unsampledReports/1')
      end
    end
  end
end
