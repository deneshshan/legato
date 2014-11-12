module Legato
  module Management
    module Updater 
      def update_or_insert(user, path=default_path, opts = {})
        request  = Legato::Management::Request.new(user, path)
        request.post(opts)
      end
    end
  end
end
