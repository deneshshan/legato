require 'json'

module Legato
  module Management
    class Request
      attr_accessor :user, :path

      def self.base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def initialize(user, path)
        @user = user
        @path = path
      end

      def uri
        if user.api_key
          # oauth + api_key
          self.class.base_uri + path + "?key=#{user.api_key}"
        else
          # oauth 2
          self.class.base_uri + path
        end
      end

      def get
        json = user.access_token.get(uri).body
        items = MultiJson.decode(json).fetch('items', [])
      end

      def post(opts = {})
        processed_opts = process(opts)
        user.access_token.post(uri, processed_opts).body
      end

    private
      def process(opts)
        processed = { }
        processed.merge({ 
          :headers => { 'Content-type' => 'application/json' },
          :body => opts.to_json
        })
      end
    end
  end
end
