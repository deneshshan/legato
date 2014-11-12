module Legato
  module Management
    # Manages the creating, getting and listing of unsampled reports.
    class UnsampledReport
      extend Finder
      extend Updater

      def path
        "/accounts/#{account_id}/webproperties/#{web_property_id}/profiles/#{profile_id}/unsampledReports/#{id}"
      end

      attr_accessor :id, :user, :account_id, :web_property_id, :profile_id,
                    :attributes

      def initialize(attributes, user)
        self.user = user
        self.id = attributes['id']
        self.account_id = attributes['accountId'] || collection_first_id(user.accounts)
        self.web_property_id = attributes['webPropertyId']  ||
          collection_first_id(user.web_properties)
        self.profile_id = attributes['profileId'] || collection_first_id(user.profiles)

        ['id', 'webPropertyId', 'profileId', 'accountId'].each { |key| attributes.delete(key) }
        self.attributes = attributes
      end

      def get
        self.class.all(user, path)
      end

      class << self
        def default_path
          '/accounts/~all/webproperties/~all/profiles/~all/unsampledReports'
        end

        def for_account(account)
          all(account.user, account.path + '/webproperties/~all/profiles/~all/unsampledReports')
        end

        def for_web_property(web_property)
          all(web_property.user, web_property.path + '/profiles/~all/unsampledReports')
        end

        def for_profile(profile)
          all(profile.user, profile.path + '/unsampledReports')
        end

        def insert(profile, opts)
          update_or_insert(profile.user, profile.path + '/unsampledReports', opts)
        end
      end

      private

      def collection_first_id(collection)
        collection.any? ? collection.first.id : '~all'
      end
    end
  end
end
