module API
  module V1
    class Root < Grape::API
      version 'v1', using: :path
      format :json

      post do
        service = Service.new
        service.create_response(params)
      end

    end
  end
end
