require 'spec_helper'

describe Legato::Management::Request do
  let(:user) { stub(:api_key => nil) }
  let(:path) { '/test' }
  let(:request) { Legato::Management::Request.new(user, path) }
  let(:base_uri) { Legato::Management::Request.base_uri }

  describe '.uri' do
    context '# oauth 1' do
      let(:user) { stub(:api_key => 123456) }

      it 'should return path including api key' do
        expect(request.uri).to eq  base_uri + path + '?key=123456'
      end
    end

    context '# oauth 2' do
      it 'should return correct path' do
        expect(request.uri).to eq base_uri + path
      end
    end
  end

  context '# making requests' do
    let(:user) { stub(:access_token => access_token, :api_key => nil) }
    let(:response) { stub(:body => 'some json') }

    describe '.get' do
      let(:access_token) { access_token = stub(:get => response) }

      after do
        user.should have_received(:access_token)
        access_token.should have_received(:get).with('https://www.googleapis.com/analytics/v3/management'+path)
        response.should have_received(:body)
        MultiJson.should have_received(:decode).with('some json')
      end

      context '# body is empty' do
        it 'should return empty array' do
          MultiJson.stubs(:decode).returns({})
          expect(request.get).to eq []
        end
      end

      context '# body not empty' do
        it 'should return an array of items' do
          MultiJson.stubs(:decode).returns({'items' => ['item1', 'item2']})
          expect(request.get).to eq ['item1', 'item2']
        end
      end
    end

    describe '.post' do
      let(:access_token) { access_token = stub(:post => response) }

      it 'should call post on access token' do
        request.post({})
        access_token.should have_received(:post)
      end
    end

    describe '.process' do
      let(:opts) { { 'hi' => 'there' } }

      it 'should process the opts correctly' do
        processed = request.send(:process, opts)
        processed.should eq({
          :headers => { 'Content-type' => 'application/json' },
          :body => "{\"hi\":\"there\"}" 
        })
      end
    end
  end
end
