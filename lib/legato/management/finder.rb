module Legato
  module Management
    module Finder
      def all(user, path=default_path)
        request = Legato::Management::Request.new(user, path)
        items = request.get
        items.map {|item| new(item, user)}
      end
    end
  end
end
